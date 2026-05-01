allprojects {
    repositories {
        google()
        mavenCentral()
    }
    //added this
     configurations.all {
        resolutionStrategy {
            force("com.google.firebase:firebase-components:18.0.0")
            force("com.google.firebase:protolite-well-known-types:18.0.0")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}
// Source - https://stackoverflow.com/a/79053205
// Posted by Oğuz Aytar
// Retrieved 2026-02-26, License - CC BY-SA 4.0



tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
