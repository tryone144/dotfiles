/*
 * STARTPAGE
 * listgenerator for startpage
 *
 * file: ~/.config/startpage.js
 * v0.2 / 2015.01.11
 *
 * (c) 2015 Bernd Busse
 */

/* JSON SYNTAX
 * JSON - LINK ELEMENT:
        {"name": "[FULL_NAME]", "link": "[TARGET_URL]"}
 * JSON - SECTION BOX:
        {"title": "[BOX_TITLE]", "elements": Array<LINK_ELEMENT>}
*/
box_media = {"title": "Media", "elements": [
        {"name": "SoundCloud", "target": "Stream", "link": "https://soundcloud.com/stream"},
        {"name": "SoundCloud", "target": "Following", "link": "https://soundcloud.com/you/following"} ]};
box_social = {"title": "Social-Networks", "elements": [
        {"name": "Facebook", "link": "https://www.facebook.com/?sk=h_chr"} ]};
box_prog = {"title": "Programming", "elements": [
        {"name": "GitHub", "link": "http://www.github.com"},
        {"name": "RegExr v2.0", "link": "http://www.regexr.com"} ]};
box_uni = {"title": "University", "elements": [
        {"name": "Blackboard", "link": "http://e-learning.rub.de"},
        {"name": "Moodle", "link": "http://moodle.rub.de"},
        {"name": "ETIT / ITS", "link": "http://etit.rub.de"} ]};

var llObject = { "sections": [
        [ box_media, box_social ],
        [ box_uni ],
        [ box_prog ],
    ]};

function genListTitle(container, title) {
    // Generate Title Element (HTML)
    var listTitle = document.createElement("h3");
    listTitle.className = "boxheader";

    // Add Title Prefix (HTML)
    listTitle.appendChild(document.createTextNode("["));

    // Generate Title span (HTML)
    var titleElement = document.createElement("span");
    titleElement.className = "blue";
    titleElement.innerHTML = title;
    listTitle.appendChild(titleElement);

    // Add Title Postfix(HTML)
    listTitle.appendChild(document.createTextNode("]:"));

    // Append Title Element (HTML)
    container.appendChild(listTitle);
}

function genListElement(container, element) {
    // Generate List Item (HTML)
    var listItem = document.createElement("a");
    listItem.href = element.link;

    // Add Name (HTML)
    listItem.appendChild(document.createTextNode(element.name));

    // Generate Target Element (HTML)
    if (element.target) {
        var targetElement = document.createElement("span");
        targetElement.className = "target";
        targetElement.innerHTML = "." + element.target;
        listItem.appendChild(targetElement);
    }

    // Append List Item (HTML)
    container.appendChild(listItem);
}

function genListBox(container, list) {
    var llTitle = list.title;
    var llElements = list.elements;

    // Generate List Element (HTML)
    var listElement = document.createElement("div");
    listElement.className = "box floatbox";
    container.appendChild(listElement);
    
    genListTitle(listElement, llTitle);
    for (var i = 0; i < llElements.length; i++) {
        genListElement(listElement, llElements[i]);
    }
}

function initList() {
    var container = document.getElementById("container");
    var llSections = llObject.sections;

    for (var c = 0; c < llSections.length; c++) {
        var listContainer = document.createElement("div");
        listContainer.className = "boxcontainer";
        container.appendChild(listContainer);
        for (var i = 0; i < llSections[c].length; i++) {
            genListBox(listContainer, llSections[c][i]);
        }
    }
}

$(document).ready( function () {
    $("input").focus(function (e) {
        $(this).parent().parent().addClass("focusedbox");
    });
    $("input").blur(function (e) {
        $(this).parent().parent().removeClass("focusedbox");
    });
});

