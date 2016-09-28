var _user$project$Native_JsonDateDecode = function() {
    function toDate(value) {
        if (value instanceof Date) {
            return _elm_lang$core$Result$Ok(value);
        } else {
            return _elm_lang$core$Result$Err("not a date value");
        }
    }

    function toJson(date) {
        return date.toJSON();
    }

    return {
        toDate: toDate,
        toJson: toJson,
    }
}();
