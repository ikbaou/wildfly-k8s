plugins {
    id("java")
    id("war")
    id("org.gretty") version "4.1.6"
}

group = "com.ibaou.experiments"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
        vendor.set(JvmVendorSpec.ADOPTIUM)
    }
}

dependencies {

    compileOnly("jakarta.servlet:jakarta.servlet-api:6.1.0")

    testImplementation(platform("org.junit:junit-bom:5.10.0"))
    testImplementation("org.junit.jupiter:junit-jupiter")
}

gretty {
    servletContainer = "jetty11"
    httpPort = 8080
    contextPath = "/"
}

tasks.test {
    useJUnitPlatform()
}
