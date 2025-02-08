let cssTime = "";
async function reloadCss() {
    // Try to load json config to web
    console.log("%c Loading settings.json", "font-size: 32px");
    try {
        await window.goofcord.loadConfig();
    } catch (error) {
        console.error(error);
    }

    // Takes new css time
    const newCssTime = window.goofcord.getConfig("quickcss_time");
    // Checks if css time has been changed
    if (cssTime !== newCssTime) {
        cssTime = newCssTime;

        // Takes the quickcss (css value)
        const quickcss = window.goofcord.getConfig("quickcss");
        console.log("%c Updating quickcss", "font-size: 32px");
        console.log({ cssTime, quickcss });

        // Sets the new css
        try {
            await window.VencordNative.quickCss.set(quickcss);
        } catch (error) {
            console.error(error);
        }
    }
}

setTimeout(() => setInterval(reloadCss, 2_000), 10_000);
