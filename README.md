# project-care
## HealthStore Usage

HealthStore is a singleton class. In order to create a reference to the global HealthStore object, use the following:
~~~~
let store:HealthStore = HealthStore.getInstance()
~~~~

getSamples() is an async function, results will be returned in the callback you provide

Params: sample type, start date, end date, callback

Returns: array of samples if not nil, error if nil

See HealthValues struct in HealthStore.swift for types of samples that can be queried

Sample query: (queries for weight samples from as far back as possible to today)
~~~~
store.getSamples(sampleType: HealthValues.bodyMass!, startDate: Date.distantPast, endDate: Date()) { (sample, error) in

    guard let samples = sample else {
        if let error = error {
            print(error)
        }
        return
    }

    //samples is an array, use to pass into another function or whatever you need
    weight = samples[samples.count-1].quantity.doubleValue(for: HKUnit.pound())
    workoutUtilities.predictCalorieBurn(level, mins, weight)
}
~~~~        
