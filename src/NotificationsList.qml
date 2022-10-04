import QtQuick 2.0

ListModel{
//    id: notificationsList

    ListElement {
        message: "To begin, press and hold the START button."
        status: "off"
        processed: false
    }

    function setSingle(message, status){
        clear()
        set(0, {message: message, status: status, processed: false})
    }

    function add(message, status){
        append({message: message, status: status, processed: false})
    }

    function removeIfpresent(message) {
        for (var i = 0; i < count; i++)
            if (get(i).message === message)
            {
                remove(i)
                return true
            }
        return false
    }

    function index(message) {
        for (var i = 0; i < count; i++)
            if (get(i).message === message)
                return i
        return -1
    }

    function getUnprocessed() {
        for (var i = 0; i < count; i++)
            if (get(i).processed === false)
                return get(i)
        return null
    }

    function process(message) {
        var idx = index(message)
        if (idx === -1){
            console.warn(`Attempted process non existingm message: ${message}`)
            return
        }
        set(idx, {processed: true})
    }
}
