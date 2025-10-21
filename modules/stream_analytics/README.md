# Stream Analytics Module - Month 2 Week 1

**Author:** Joel Maison  
**Date:** October 21, 2025  
**Status:** Code Complete - Awaiting Provider Registration for Deployment

---

## Overview

This module provides Infrastructure-as-Code (IaC) for deploying Azure Stream Analytics jobs to process real-time streaming data from Husk Power Systems' renewable energy infrastructure.

---

## Analysis of Current State

### Existing Stream Analytics Resources
**Finding:** No existing Stream Analytics jobs were found in the Azure subscription (as authorizations are needed to perform the necessary actions)

**Analysis Method:**
- Checked Azure Portal for Stream Analytics jobs
- Result: "No stream analytics jobs to display"
- Conclusion: Starting from scratch

---

## Proposed Architecture

### Use Case
Process real-time telemetry data from Husk Power Systems' distributed mini-grid installations across rural communities.

### Example of Data Flow to be confirmed by Supervisor
```
IoT Devices (Solar/Biomass Systems)
    ↓
Event Hub (Input)
    ↓
Stream Analytics Job (Real-time Processing)
    ↓
Synapse SQL Pool (Output - Analytics)
```

### Input Sources (Planned) - Because they are not yet known
- **Primary Input:** Azure Event Hub
  - Purpose: Receive IoT sensor data from mini-grid installations
  - Expected Data: Power generation metrics, consumption patterns, battery status
  - Format: JSON

### Output Destinations (Planned) - Because they are not yet known
- **Primary Output:** Azure Synapse Analytics SQL Pool
  - Purpose: Store processed data for analytics and reporting
  - Data: Aggregated power metrics, anomaly detection results

### Transformation Logic
Current implementation includes a basic pass-through query. Future transformations will include:
- Real-time aggregation of power generation metrics
- Anomaly detection for equipment failures
- Time-windowed analysis (5-minute, hourly, daily aggregates)

---

## Autoscaling Patterns

### Current Status
⚠️ **Autoscaling patterns are preliminary estimates** and require validation.

### Proposed Configuration (To Be Validated)
- **Initial deployment:** 3 streaming units (baseline)
- **Monitoring period:** 2 weeks to establish baseline metrics
- **Scaling strategy:** TBD based on actual data patterns

### Required Information (For subsequent weeks)
To properly configure autoscaling, we need(for instance):
1. **Data volume metrics:**
   - How many mini-grid sites are sending data?
   - How many sensors per site?
   - What's the reporting frequency?

2. **Usage patterns:**
   - Peak usage times (time of day, day of week)
   - Expected growth rate
   - Seasonal variations

3. **Performance requirements:**
   - Maximum acceptable latency
   - Data freshness requirements
   - SLA requirements

### Recommended Approach
1. Deploy with fixed 1 streaming units initially
2. Monitor for 1-2 weeks to gather metrics:
   - Input event rate
   - Processing lag
   - Resource utilization
3. Analyze patterns and configure autoscaling based on real data
4. Document final configuration

---

## Throughput Requirements

### Current Status
⚠️ **Throughput requirements are estimated** and require validation with actual system specifications(to be provided by supervisor)

### Validation Required
Before finalizing streaming unit allocation, confirm:
1. Actual number of data sources
2. Event size (bytes per event)
3. Query complexity requirements
4. Latency tolerance

### Recommendation
Start with **1 streaming units** and monitor:
- Input event backlog
- Watermark delay
- CPU/memory utilization
- Processing time

Adjust streaming units based on observed performance.

---

## Security Configuration

### Network Security
- Public network access enabled (can be restricted post-deployment)
- Integration with Managed Virtual Network (future enhancement)

### Authentication
- Managed Identity integration with Synapse
- Azure authentication for inputs/outputs
- No stored credentials in code

### Data Protection
- TLS 1.2 minimum for all connections
- Encryption at rest (Azure default)
- Data locale: en-US (compliance requirement)

---

## Deployment Status

### Completed ✅
- [x] Analysis of existing Stream Analytics resources (none found)
- [x] Stream Analytics module structure created (`modules/stream_analytics/`)
- [x] Module variables defined (`variables.tf`)
- [x] Main resource configuration written (`main.tf`)
- [x] Output definitions created (`outputs.tf`)
- [x] Integration with root module (`main.tf` module call)
- [x] Basic transformation query template
- [x] Preliminary autoscaling strategy documented
- [x] Throughput requirements framework established
- [x] Security configuration defined
- [x] Documentation completed (this README)
- [x] Code pushed to GitHub repository

### In Progress 🔄
- [ ] Synapse workspace deployment (partially complete - some resources deployed)
  - [x] Storage Account created
  - [x] Storage Container created
  - [x] Synapse Workspace created
  - [x] Synapse SQL Pool created
  - [x] Synapse Spark Pool created
  - [ ] Synapse Firewall Rule (error - name needs correction)
  
### Blocked ⏸️
- [ ] Stream Analytics deployment
  - **Reason:** `Microsoft.StreamAnalytics` provider not registered in subscription
  - **Error:** `MissingSubscriptionRegistration`
  - **Permission required:** Subscription Owner/Contributor role to register provider
  - **Action needed:** Contact Azure administrator to run:
```bash
    az provider register --namespace Microsoft.StreamAnalytics
```

### Pending Validation ⚠️
- [ ] Actual data source specifications (sensor count, frequency, volume)
- [ ] Real throughput requirements from stakeholders
- [ ] Production autoscaling patterns based on monitoring data
- [ ] Input source confirmation (Event Hub vs IoT Hub vs other)
- [ ] Output destination confirmation (Synapse vs other targets)
- [ ] Detailed transformation logic requirements

### Next Steps (To be discussed with supervisor) 📋

**Immediate Actions:**
1. Work with Azure administrator to register `Microsoft.StreamAnalytics` provider
2. Fix Synapse firewall rule name (`AllowAllWindowsAzureIps`)
3. Complete Synapse deployment (`tofu apply`)

**Configuration Tasks:**
4. Gather actual requirements from supervisors:
   - Data formats
   - Data reporting frequency
   - Expected data volume
5. Define actual Event Hub input configuration
6. Define Synapse SQL Pool output configuration
7. Implement detailed transformation query based on real requirements

**Testing & Optimization:**
8. Deploy Stream Analytics job
9. Configure monitoring and alerting
10. Test with sample/production data
11. Monitor performance 
12. Adjust streaming units based on actual metrics
13. Configure autoscaling based on observed patterns
14. Document operational procedures and findings

---

## Module Usage

### Prerequisites
- Azure subscription with `Microsoft.StreamAnalytics` provider registered
- Existing resource group
- Event Hub (for input)
- Synapse workspace (for output)

### Example Deployment (To be determined by supervisor)
```hcl
module "stream_analytics" {
  source = "./modules/stream_analytics"

  name                = "husk-power-stream"
  resource_group_name = "rg-prod-in-cmu"
  location            = "southindia"
  streaming_units     = 1  # For a start
  
  transformation_query = <<QUERY
    SELECT
        DeviceId,
        AVG(PowerGeneration) as AvgPower,
        MAX(BatteryLevel) as MaxBattery,
        System.Timestamp() as WindowEnd
    INTO
        [synapse-output]
    FROM
        [eventhub-input]
    TIMESTAMP BY EventTime
    GROUP BY
        DeviceId,
        TumblingWindow(minute, 5)
  QUERY

  tags = {
    Environment = "production"
    Project     = "renewable-energy-monitoring"
  }
}
```

---

## References

- [Azure Stream Analytics Documentation](https://docs.microsoft.com/en-us/azure/stream-analytics/)
- [Husk Power Systems IaC Practicum Roadmap](../../README.md)
- [OpenTofu Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)


