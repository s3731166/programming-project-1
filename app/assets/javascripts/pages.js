function change_plant(dropdown_menu) {
    var checklist_divs = document.getElementsByClassName("dashboard-plant-info");
    for (var i = 0; i<checklist_divs.length; i++) {
        checklist_divs[i].classList.add("hide");
    }
    if (dropdown_menu.value) {
        document.getElementById("plant-"+dropdown_menu.value).classList.remove("hide");
    }
}