plugins {
    id("java")
    id("war")
    id("org.gretty") version "4.1.6"
    id("maven-publish")
}

group = "com.ibaou.experiments"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
    maven {
        name = "nexus"
        url = uri("https://repo.local/repository/repo.maven.local/")
        isAllowInsecureProtocol = true
    }

}

publishing {
    publications {
        create<MavenPublication>("war") {
            artifact(tasks.named("war"))
        }
    }

    repositories {
        maven {
            name = "nexus"
            url = uri("https://repo.local/repository/repo.maven.local/")
            isAllowInsecureProtocol = true
            credentials {
                username = findProperty("nexusUsername") as String?
                    ?: System.getenv("NEXUS_USERNAME")
                password = findProperty("nexusPassword") as String?
                    ?: System.getenv("NEXUS_PASSWORD")
            }
        }
    }
}

dependencies {
    providedCompile("jakarta.servlet:jakarta.servlet-api:6.1.0")
    testImplementation(platform("org.junit:junit-bom:5.10.0"))
    testImplementation("org.junit.jupiter:junit-jupiter")
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
        vendor.set(JvmVendorSpec.ADOPTIUM)
    }
}

gretty {
    servletContainer = "jetty11"
    httpPort = 8080
    contextPath = "/"
}

tasks.war {
    archiveFileName = "${project.name}.war"
}

tasks.test {
    useJUnitPlatform()
}
