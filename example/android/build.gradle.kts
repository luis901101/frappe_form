import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.set(file("../build"))
subprojects {
    project.layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(project.name))
}
subprojects {
    project.evaluationDependsOn(":app")
}
subprojects {
    // While android.builtInKotlin=false, a Kotlin plugin needs kotlin-android.
    // Flutter only auto-applies it when a regex finds no KGP line in the plugin's
    // build file, so plugins that guard that line behind an AGP < 9 check
    // (e.g. file_picker 11) get neither, and their Kotlin classes never compile.
    // Applying it here when AGP's library plugin lands covers them; for plugins
    // that apply it themselves, the second apply is a no-op. Kotlin then targets
    // the running JDK unless told otherwise, so match each variant's Java target,
    // as built-in Kotlin would.
    pluginManager.withPlugin("com.android.library") {
        pluginManager.apply("org.jetbrains.kotlin.android")
        tasks.withType<KotlinCompile>().configureEach {
            val javacName = name.replace("Kotlin", "JavaWithJavac")
            // A plain provider, not javac.map, so Kotlin does not depend on javac,
            // which itself depends on Kotlin.
            compilerOptions.jvmTarget.set(provider {
                JvmTarget.fromTarget(tasks.getByName<JavaCompile>(javacName).targetCompatibility)
            })
        }
    }
}
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
