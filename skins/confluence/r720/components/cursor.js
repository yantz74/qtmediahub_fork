function initialize() {
    if (typeof runtime.cursor  != 'undefined') {
        runtime.cursor.defaultCursorPath = themeResourcePath + "/media/pointer-focus.png"
        runtime.cursor.clickedCursorPath = themeResourcePath + "/media/pointer-focus-click.png"
    }
}

