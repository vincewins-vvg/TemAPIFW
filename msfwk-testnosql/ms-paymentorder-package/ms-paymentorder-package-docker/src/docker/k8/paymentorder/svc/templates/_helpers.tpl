{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "paymentorder.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "paymentorder.fullname" -}}
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
{{- define "paymentorder.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "paymentorder.labels" -}}
helm.sh/chart: {{ include "paymentorder.chart" . }}
{{ include "paymentorder.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "paymentorderapi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "paymentorder.name" . }}{{ "-api" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "paymentorderingester.selectorLabels" -}}
app.kubernetes.io/name: {{ include "paymentorder.name" . }}{{ "-ingester" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "paymentorderscheduler.selectorLabels" -}}
app.kubernetes.io/name: {{ include "paymentorder.name" . }}{{ "-scheduler" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the proper image name
*/}}
{{- define "paymentorderapi.image"}}
{{- if .Values.image.registry }}
{{- .Values.image.registry | trimSuffix "/" }}{{ "/" }}
{{- end }}
{{- .Values.image.paymentorderapi.repository }}{{ ":" }}
{{- default .Chart.AppVersion .Values.image.paymentorderapi.tag }}
{{- end }}

{{- define "paymentorderingester.image"}}
{{- if .Values.image.registry }}
{{- .Values.image.registry | trimSuffix "/" }}{{ "/" }}
{{- end }}
{{- .Values.image.paymentorderingester.repository }}{{ ":" }}
{{- default .Chart.AppVersion .Values.image.paymentorderingester.tag }}
{{- end }}

{{- define "schemaregistry.image"}}
{{- if .Values.image.registry }}
{{- .Values.image.registry | trimSuffix "/" }}{{ "/" }}
{{- end }}
{{- .Values.image.schemaregistry.repository }}{{ ":" }}
{{- default .Chart.AppVersion .Values.image.schemaregistry.tag }}
{{- end }}

{{- define "paymentorderscheduler.image"}}
{{- if .Values.image.registry }}
{{- .Values.image.registry | trimSuffix "/" }}{{ "/" }}
{{- end }}
{{- .Values.image.paymentorderscheduler.repository }}{{ ":" }}
{{- default .Chart.AppVersion .Values.image.paymentorderscheduler.tag }}
{{- end }}
