// Startet die Flutter-Demos (flutter-demos/, Build nach /assets/flutter/) auf Seiten mit dem Makro flutterDemo.
// Eine Engine pro Seite im Multi-View-Modus, eine View pro Demo. Bis die Engine läuft, bleibt das Bild sichtbar.
(function() {
const BASE = "/assets/flutter/";
const hosts = document.querySelectorAll(".flutter-demo");
if (!hosts.length) return;

const isDark = () => document.querySelector(".boxed-image.dark") !== null;

function loadScript(src) {
    return new Promise((resolve, reject) => {
        const script = document.createElement("script");
        script.src = src;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
    });
}

async function start() {
    await loadScript(BASE + "flutter_bootstrap.js");
    _flutter.loader.load({
        config: {
            entrypointBaseUrl: BASE,
            canvasKitBaseUrl: BASE + "canvaskit/",
        },
        onEntrypointLoaded: async (engineInitializer) => {
            const engine = await engineInitializer.initializeEngine({
                multiViewEnabled: true,
                assetBase: BASE,
            });
            const app = await engine.runApp();
            hosts.forEach((host) => {
                app.addView({
                    hostElement: host.querySelector(".flutter-demo-view"),
                    initialData: { demo: host.dataset.demo, dark: isDark() },
                });
                host.classList.add("is-live");
            });
        },
    });
}

// Hell/Dunkel-Umschalter (mode-toggle.js) setzt die Klassen light/dark auf den Boxen
const box = hosts[0].closest(".boxed-image");
new MutationObserver(() => {
    if (window.sbbFlutterDemosSetDarkMode) window.sbbFlutterDemosSetDarkMode(isDark());
}).observe(box, { attributes: true, attributeFilter: ["class"] });

// Engine erst laden, wenn die erste Demo in die Nähe des Viewports kommt (ca. 2 MB plus CanvasKit)
const observer = new IntersectionObserver((entries) => {
    if (entries.some((entry) => entry.isIntersecting)) {
        observer.disconnect();
        start().catch((error) => console.error("Flutter demos could not start", error));
    }
}, { rootMargin: "400px" });
hosts.forEach((host) => observer.observe(host));
})();
