HPSF
====
Eonil.

HPSF stands for "High Performance SwiftUI Foundation".
This is essentially a collection of code to support making high performance apps UI using SwiftUI.


File Structure
--------------
- Root package `HPSF` is an aggregation-only package. (no code, re-export only)
- Subpackage `HPSFImpl1` contains all code there.
- Subpacakge `HPSFSample` contains app-level sample there.
- Subproject `HPSFSampleApp` contains Xcode project for app-package there.
    
To Do
-----
- Make `HPLazyVList`.
    - No scroll view. This is just a fixed-sized view for certain data input.
    - Designed to be used as contained in a scroll-view.
    - Provides Viewport bounding box culling.
    - Provides container bounding box culling.
    - Provides intrinsic size.
    - Homogeneous segment views. 
- Make test suite.
    - Which collects call count to view-graph reconstruction (`body`) and checks certain call counts.


Problems & Solutions
-----------------------------

### Slow list rendering.
- Problem.
    - `LazyVStack` doesn't work as expected. It instantiates all items at once.
    - Cells are always re-rendered.
- Solution.
    - Implement our own list renderer.
    - iOS 15 does not have proper support.
        - Use hack (`UIHostingController`) for older versions.
        - Use proper solution for iOS 17+.
    - iOS 17 `SwiftUI.ScrollView` scroll is unstable if content-size changes.
        - This also happens in `UIScrollView`.
        - Solution is recovering scroll position after resizing content-size.
        - But, this is unusable with `SwiftUI.ScrollView`.
        - Just use iOS 15 based solution until we get a better solution for this.
    - Avoid re-rendering by tracking old cell indices.
        - This is still best effort level.
    - Use "timeline"-based rendering.
        - Track & record changes precisely.
        - Pass "timeline" as-is to UI, so can be rendered optimally.

### Lack of paged scroll-view.
- Problem.
    - Scroll-view paging is lacked in iOS 15.
    - People tend to reimplement the functionality or try hacks such as introspection.
- Solution.
    - Implement dedicated paged-scroll-view.

### Rendering in invisible state.
- Problem.
    - In major navigation state, only one or two "pages" (a view covering whole screen) are actively visible.
    - All other pages are hidden by other pages.
- Solution.
    - Define complete navigation state and render only it matches.
    - Define a pattern/convention to make this easy.
        - Use `HPConditionallyUpdatedView`.
            - This suspends/resumes view update according to the condition.
            - It does not erase existing view-graph. All view-states will be kept and remain as-is. 

### All "pages" are re-rendered for all repo changes.
- Problem.
    - We have hundreds of pages.
    - They will be re-rendered for every kind of changes. 10 times per second at worst.
    - Although that won't be a big burden, it's still an burden and contributing to the CPU load. 
- Solution.
    - Do not trigger re-rendering at "page" level.
    - Make "pages" to depend only on navigation state.
        - It no longer depend on repo. So it won't be re-rendered on repo changes.
    - Instead, observe repo changes from all each "pages".
    - By the way, this is a last resort method.
        - If we do not trigger re-rendering of pages while they are hidden,
        - It becomes just thoudsands of functions call which runs single equality comparison. (see above solution)
        - Also, nested pages under hidden tab won't even get checked.
        - At last, only root tabs will be triggered for re-rendering. 

### We have to trigger re-rendering even for small portion of view changes.
- Problem.
    - In many cases, view is built with complicated layout and only 1 or 2 leaf elements changes.
    - But to trigger the change, we have to trigger re-rendering of whole subtree.
- Solution.
    - Divide static part and dynamic part in a view.
    - Make static part static by taking no parameter.
    - Overlay dynamic part over the static view. Tune layout precisely to make it positioned properly.

Potential Problems & Solutions
------------------------------
        
### Simply too much text rendering.
- Problem.
    - Text rendering is one of major CPU consumption point.
    - If we have too many thing to render, there's no way work-around.
    - Text size measuring also expensive.
    - Whatever we do, it's absolutely too much amount.
- Solution.
    - Minimize re-rendering.
        - Divide & conquer. Divide text into smaller parts to minimize changing parts. 
    - Refactor layout which not to depend on text size measuring.
        - Prevent situation by prohibiting default `Text` view.
        - Define & use `HPText` which always needs explicit pre-defined size.
    - Utilize cache.
        - Most text instances are once rendered and displayed on screen for dozens of frames.
            - They are intended to be read by humans. If it changes too fast, it's not very useful.
        - If it's not utilizing cache very well, there must be a room for improvments, and it will be huge.
        - Cache rasterized text image and do not re-render them
            - We can calculate needed memory size quite precisely.
            - Cache them even as long as possible. Because once hidden text instances ca be shown again later.
            - Cache them using the original string & style as key.
                - Even if we use quite long text, it's still far cheaper then re-rendering.
                - Hashed search will make it even faster.
        - Cache rasterized text dimensions (size) too. Do not re-calculate them.
            - They are needed to help layout. 
            - Many of layout are depending on measured text sizes.
            - If we do not need to recalculate them, it will be huge win.     
    - Increase cache hit rate.
        - Split elements into smaller parts, so they can be cached better.
        - Make final text rendering as pure function. Accepts text, fonts and all other needed parameters.
    - Optimize font data. Or use optimized font.
        - Fonts are defined in complicated bezier curves.
        - Compliexity of the curve directly affects to rendering speed.
        - If we can employ simpler curves, it will be rendered faster although overall quality would drop a bit. (Google does this)
        - Optimize fonts by refitting their curves.
        - But effect is suspicious as Apple could already have done this.
    - Use faster font rasterizer.
        - We don't know which rasterization implementation `CoreText` is using. (known as `freetype`)
        - We have `font-rs`, which provides 5-7 times faster rasterization. (but with no layout support)
        - We also have `fontdue`, which is based on `font-rs`, and provides 2-3 times faster text rendering.
        - Replace all font rendering with them.
    - Make a specialized "number" rendering view. (including some punctuations)
        - As a financial app, we need to display many numbers. Sometimes a screen is fully covered by numbers.
        - Also, numbers are very frequently updated. 
        - If we have to optimize only one place extremly, it should be the number display.
        - Decompose, pre-rasterize, and compose bitmaps using GPU. (`CALayer`)
            - For recompose, we need sub-pixel level precision.
            - Render numbers with super-sampling, and resize them using GPU filter.
                - Super-sample by 2x2 to 4x4 times pixels. 
                - Drops quality a bit, but should be acceptable.
            - Compose them at floating-point number space.
                - Re-sampling would occur, but it will be fine as we have super-sampled them.
                    - Anti-alising is pre-applied, GPU texture filtering would also play a role.
                    - Quality drop will be acceptable.
        - No advanced layout feature support. This is an optimization on purpose.
        - We also can fallback to full quality rendeing selectively.
    - Utilize fixed-width fonts. 
        - Usually, `CoreText` lays out & renders everything at paragraph level.
        - This means while paragraphs need to be re-rendered even a part of it changes.
        - We can avoid re-rendering at glyph level with fixed fonts.
        - Number representation will be the best fit for this.
        - By the way, I'm suspicious how much this would be effective.
            - Sub-piexl level layout is still performed. We can't avoid re-rendering. 


Discarded Solutions
-------------------
- Static view.
    - A container view never updates contained views.
    - This is not necessary as this is default behavior of SwiftUI.
- Size-predefined vertical stack view.
    - No good way to provide different type of content segment views.
    - It's essentially same with setting fixed sizes to all content view in a `VStack`.
    - SwiftUI is known to perform viewport culling by default.
        - Still may involve layout recalculation, but it can be avoided by providing fixed sizes to all content views.     
