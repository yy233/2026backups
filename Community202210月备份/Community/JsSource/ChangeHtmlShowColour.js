function white() {
    document.body.style.backgroundColor = "white"
    document.body.style.color = "#6E727D"
    document.body.style.fontSize = "15px"
}

function night() {
    document.body.style.backgroundColor = "rgba(0, 21, 52, 1)"
    document.body.style.color = "#F5F5F5"
    document.body.style.fontSize = "15px"
    let a = document.getElementsByTagName("strong")
    for (var i = 0; i < a.length; i++) {
        console.log(i)
        a[i].style.color="#F5F5F5"
    } 
}

function custom(i) {
    // white表示白色
    if (i == 'white') {
        this.white()
    }
    // white表示黑色
    if (i == "night") {
        this.night()
    }

}
