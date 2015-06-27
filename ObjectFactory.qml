import QtQuick 2.0

QtObject {
    function instantiateFromFile(parent, filename, memberData) {
        console.log("Attempting to create a component object from " + filename + ".");
        var component = Qt.createComponent(filename);

        if (component.status !== Component.Ready) {
            console.error("Component data from " + filename + " not found.");
            return null;
        }
/*
        var obj = component.createObject(parent, memberData);

        if (obj === null) {
            console.error("Unable to create a component from " + filename + ".");
            console.error(component.errorString());
        }
        else {
            console.log("Successfully instantiated the component " + filename + ".");
        }
*/
        console.log("Successfully instantiated the component " + filename + ".");
        return component;
    }
}

