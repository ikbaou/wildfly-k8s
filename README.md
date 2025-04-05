# Introduction

## Build and run standalone
### Pre-requisites
not much, gradlew will handle JDK download and fire up a jetty instance on port 8080
```
gradlew appRun
```
you should see something like:
```2025-04-05 18:58:46.032:INFO :oejs.Server:main: jetty-11.0.17; built: 2023-10-09T18:39:14.424Z; git: 48e7716b9462bebea6732b885dbebb4300787a5c; jvm 21.0.6+7-LTS
2025-04-05 18:58:54.107:INFO :oejs.AbstractConnector:main: Started ServerConnector@488b50ec{HTTP/1.1, (http/1.1)}{0.0.0.0:8080}
2025-04-05 18:58:54.120:INFO :oejs.Server:main: Started Server@2df3c564{STARTING}[11.0.17,sto=0] @9206ms
2025-04-05 18:58:54.456:INFO :oejss.DefaultSessionIdManager:main: Session workerName=node0
2025-04-05 18:58:54.473:INFO :oejsh.ContextHandler:main: Started o.a.g.JettyWebAppContext@7ca8d498{/,/,file:///...reducted.../wildfly-k8s/build/inplaceWebapp/,AVAILABLE}
2025-04-05 18:58:54.478:INFO :oag.JettyConfigurerImpl:main: Jetty 11.0.17 started and listening on port 8080
2025-04-05 18:58:54.488:INFO :oag.JettyConfigurerImpl:main:  runs at:
2025-04-05 18:58:54.489:INFO :oag.JettyConfigurerImpl:main:   http://localhost:8080/
```

- check health via [health endpoint](http://localhost:8080/health)
- test session via [session endpoint](http://localhost:8080/test)
- invalidate session via [session endpoint](http://localhost:8080/test?invalidate=true)
