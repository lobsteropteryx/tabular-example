# Automating Tabular Model Deployments

An example project for doing automated deployment and testing with Microsoft Analysis Services Tabular Models.  See blog posts [here](http://notesfromthelifeboat.com/post/analysis-services-1-deployment/) and [here](http://notesfromthelifeboat.com/post/analysis-services-2-testing) for a detailed walkthrough.

## Quick Start

### Build and Deploy Model

```powershell
.\deploy_model.ps1 -workspace c:\develop\tabular-automation -environment validation -analysisServicesUsername test_ssas -analysisSer
vicesPassword test_ssas
```

### Refresh Model Data

```powershell
.\refresh.ps1 -environment validation -analysisServicesUsername test_ssas -analysisServicesPassword test_ssas
```