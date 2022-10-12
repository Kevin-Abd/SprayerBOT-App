import QtQuick 2.0

ListModel{
//    id: notificationsList

    ListElement {
        message: "To begin, press and hold the START button."
        code: "001"
        status: "off"
        processed: false
    }

    function setSingle(code, message, status){
        clear()
        set(0, {code: code, message: message, status: status, processed: false})
    }

    function add(code, message, status){
        append({code: code, message: message, status: status, processed: false})
    }

    function removeIfpresent(code) {
        for (var i = 0; i < count; i++)
            if (get(i).code === code)
            {
                remove(i)
                return true
            }
        return false
    }

    function index(code) {
        for (var i = 0; i < count; i++)
            if (get(i).code === code)
                return i
        return -1
    }

    function getUnprocessed() {
        for (var i = 0; i < count; i++)
            if (get(i).processed === false)
                return get(i)
        return null
    }

    function process(code) {
        var idx = index(code)
        if (idx === -1){
            console.warn(`Attempted process non existant alert (code: ${code})`)
            return
        }
        set(idx, {processed: true})
    }
}
