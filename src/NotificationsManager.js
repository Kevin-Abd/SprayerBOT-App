function numberOfEntries(notificationsList, arg) {
    var num = 0
    for (var i = 0; i < notificationsList.count; i++) {
        var msg = notificationsList.get(i).message;
        if (msg === arg) {
            num++
        }
    }
    return num
}

function removeNotification(notificationsList, arg) {
    for (var i = 0; i < notificationsList.count; i++) {
        var msg = notificationsList.get(i).message;
        if (msg === arg) {
            notificationsList.remove(i);
        }
    }
}
