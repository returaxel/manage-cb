# cros-mgmt

**PROVIDED AS IS - USE AT YOUR OWN RISK - NO WARRANTY**

## Prereq
* GAM (https://github.com/jay0lee/GAM#start-of-content) 

## Application
* Fetch deviceID using serial number
* Actions: ReEnable, Disable, Deprovision, Info
* Log date, serialnumber & action taken to file

## Examples
**Use**
```PS
Getting all CrOS Devices in G Suite account that match query (id:5ER14LN0) (may take some time on a large account)...
Got 1 CrOS Devices...
done.
CrOS Device: D3V1C31D-D3V1C31D-D3V1C31D-D3V1C31D-D3V1C31D (1 of 1)
  annotatedUser: mail@domain...
  lastSync: 2011-11-11T11:00:11.832Z
  serialNumber: 5ER14LN05ER14LN0
  status: DEPROVISIONED
```

**Logging**
>07/05/2019 11:10:21, serialnumber, info

>07/05/2019 11:10:51, serialnumber, reenable

## Finally
**PROVIDED AS IS - USE AT YOUR OWN RISK - NO WARRANTY**
