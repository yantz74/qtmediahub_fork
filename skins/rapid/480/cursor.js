function initialize() {
    if (typeof(cursor) != 'undefined') {
        cursor.idleTimeout = 2
        cursor.defaultCursorPath = themeResourcePath + "/media/pointer-focus.png"
        cursor.clickedCursorPath = themeResourcePath + "/media/pointer-focus-click.png"
    }
}

// script.js
var myArray = new Array()

function getIndex(row, column) {
    return (row*3)+column // the 3 is a hack ...
}

function addItem(item, row, column) {
    myArray[getIndex(row,column)] = item
}

function getItem(row, column) {
    return myArray[getIndex(row, column)]
}
