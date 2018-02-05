**Notes:**

 1. Use HKObserverQuery to know when data has been updated
 2. Start a HKWorkoutSession (usually on iOS app - if started on watch needs to end on watch. If started on iOS app need to check if session is already started before starting on watch) for sensor reading to happen more frequently
 3. Use WatchConnectivity Framework to connect Apple Watch and iOS app data, for more accurate real-time readings (because heart-rate is measured entirely on watch, but all HealthKit queries are from the iOS app
