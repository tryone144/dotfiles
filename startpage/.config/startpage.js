/*
 * STARTPAGE
 * listgenerator for startpage
 *
 * file: ~/.config/startpage.js
 * v0.1 / 2015.01.10
 *
 * (c) 2015 Bernd Busse
 */
var llObject = { "sections": [
        {"title": "Media", "elements": [
            {"name": "SoundCloud", "target": "Stream", "link": "https://soundcloud.com/stream"},
            {"name": "SoundCloud", "target": "Following", "link": "https://soundcloud.com/you/following"},
        ]},
        {"title": "Social-Networks", "elements": [
            {"name": "Facebook", "link": "https://www.facebook.com/?sk=h_chr"},
        ]},
        {"title": "Programming", "elements": [
            {"name": "GitHub", "link": "http://www.github.com"},
            {"name": "RegExr v2.0", "link": "http://www.regexr.com"},
        ]},
    ]};

function genListTitle(container, title) {
    // Generate Title Element (HTML)
    var listTitle = document.createElement("div");
    listTitle.className = "linkheader";

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
        targetElement.innerHTML = " [" + element.target + "]";
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
    listElement.className = "linkbox";
    container.appendChild(listElement);
    
    genListTitle(listElement, llTitle);
    for (var i = 0; i < llElements.length; i++) {
        genListElement(listElement, llElements[i]);
    }
}

function initList() {
    var listContainer = document.getElementById("boxcontainer");
    var llSections = llObject.sections;

    for (var i = 0; i < llSections.length; i++) {
        genListBox(listContainer, llSections[i]);
    }
}

