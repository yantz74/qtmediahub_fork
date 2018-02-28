TEMPLATE = subdirs
SUBDIRS = qtmediahub-core

isEmpty(PROJECTROOT) {
    message("Building without a rational PROJECTROOT is undefined")
    error("Did you run configure?")
}
