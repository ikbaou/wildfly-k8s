{{/*
Expand the name of the chart.
*/}}
{{- define "wildfly-k8s.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wildfly-k8s.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wildfly-k8s.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wildfly-k8s.labels" -}}
helm.sh/chart: {{ include "wildfly-k8s.chart" . }}
{{ include "wildfly-k8s.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wildfly-k8s.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wildfly-k8s.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "wildfly-k8s.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "wildfly-k8s.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate Wildfly CLI script
*/}}
{{- define "wildfly.cliScript" -}}

{{- if .Values.wildfly.cli.logging }}
#logging
/subsystem=logging/pattern-formatter=STDOUT-FORMATTER:add(pattern="%s%n")
/subsystem=logging/console-handler=STDOUT-HANDLER:add(named-formatter=STDOUT-FORMATTER, autoflush=true, target=System.out)
/subsystem=logging/logger=stdout:add(use-parent-handlers=false, handlers=[STDOUT-HANDLER])
/subsystem=logging/logger=org.hibernate.orm.deprecation:add
/subsystem=logging/logger=org.hibernate.orm.deprecation:write-attribute(name="level", value="ERROR")
{{- end }}

{{- if .Values.wildfly.cli.jsp }}
#JSP
/system-property=org.apache.jasper.compiler.Parser.STRICT_WHITESPACE:add(value=false)
{{- end }}

{{- if .Values.wildfly.cli.k8s }}
#kuberenetes
/subsystem=jgroups/stack=tcp/protocol=MPING:remove()
/subsystem=jgroups/stack=tcp/protocol=kubernetes.KUBE_PING:add(add-index=0,properties={namespace="{{ .Release.Namespace }}",labels="app.kubernetes.io/instance={{ .Release.Name }}"})
/subsystem=jgroups/channel=ee:write-attribute(name=stack,value=tcp)
/subsystem=jgroups/stack=udp:remove()
{{- end }}

{{- if .Values.wildfly.cli.jaas }}
#JAAS Security
/subsystem=security/security-domain=CeprocLoginModule:add(cache-type=default)
/subsystem=security/security-domain=CeprocLoginModule/authentication=classic:add
/subsystem=security/security-domain=CeprocLoginModule/authentication=classic/login-module=CeprocLoginModule:add(code=com.ed.ecomm.edcore.web.jaas.EDDummyLoginModule,flag=sufficient)
{{- end }}

{{- if .Values.wildfly.cli.jms.enabled }}
#JMS
{{- range .Values.wildfly.cli.jms.queues }}
jms-queue add --queue-address={{ . }} --entries=java:/jms/queue/{{ . }}
{{- end }}
{{- range .Values.wildfly.cli.jms.topics }}
jms-topic add --topic-address={{ . }} --entries=java:/jms/topic/{{ . }}
{{- end }}
{{- end }} # end if JMS
{{- end }} #end wildfly.cliScript
