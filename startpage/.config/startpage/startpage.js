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
        {"name": "Facebook", "target": "News", "link": "https://www.facebook.com/?sk=h_chr"},
        {"name": "Facebook", "target": "Profile", "link": "https://www.facebook.com/me"} ]};
box_prog = {"title": "Programming", "elements": [
        {"name": "RegExr v2.0", "link": "http://www.regexr.com/"},
        {"name": "JSFiddle", "link": "http://jsfiddle.net/"} ]};
box_uni = {"title": "University", "elements": [
        {"name": "Blackboard", "link": "https://e-learning.ruhr-uni-bochum.de/bin/bbupdate/bb_login.pl"},
        {"name": "Moodle", "link": "https://moodle.ruhr-uni-bochum.de/"},
        {"name": "W3L", "target": "Startseite", "link": "http://w3l.swt.rub.de/w3l/jsp/startseite/index.jsp?navID=startseite"},
        {"name": "W3L", "target": "Übungen", "link": "http://w3l.swt.rub.de/w3l/jsp/startseite/index.jsp?navID=107_1406594"} ]};
box_jw = {"title": "JW.ORG", "elements": [
        {"name": "JW.org", "link": "http://www.jw.org/de/"},
        {"name": "JW Broadcasting", "link": "http://tv.jw.org/#home"},
        {"name": "WOL", "target": "Daily Text", "link": "http://wol.jw.org/de/wol/h/r10/lp-x"},
        {"name": "WOL", "target": "Bible", "link": "http://wol.jw.org/de/wol/binav/r10/lp-x/Rbi8/X/1986"} ]};
box_net = {"title": "Networks", "elements": [
        {"name": "Firewall", "link": "https://ipfire.bussenet.de:444/cgi-bin/index.cgi"},
        {"name": "RZ-Login", "link": "https://login.rz.ruhr-uni-bochum.de"} ]};

var llObject = { "sections": [
        [ box_media, box_social ],
        [ box_uni, box_jw ],
        [ box_prog ],
        [ box_net ],
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

