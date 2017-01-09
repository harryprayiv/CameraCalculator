// Exposure Calc
// Harry Pray IV 2016
//__________________________________________________________

import UIKit

typealias Rational = (num : Int, den : Int)

func rationalApproximationOf(x0: Double, withPrecision eps: Double = 1.0E-6) -> Rational {
    var x = x0
    var a = floor(x)
    var (h1, k1, h, k) = (1, 0, Int(a), 1)
    
    while x - a > eps * Double(k) * Double(k) {
        x = 1.0/(x - a)
        a = floor(x)
        (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
    }
    return (h, k)
}

func lVtoLux(_ LV:Double) -> Double{
    return ((pow(2, LV))*2.5)
}

func lVtoFC(_ LV:Double) -> Double{
    return (((pow(2, LV))*2.5)/10.76)
}

func lVtoLumens(_ LV:Double) -> Double{
    return ((pow(2, LV))*2.5)
}


func exposureCalc(tStop aperture: Double?,ISO iSO: Double?,shutter shutterTime: Double?, LV:Double?) -> (String,Double){
    
    if aperture != nil && iSO != nil && shutterTime != nil && LV == nil {
        
        //LV calculation
        let answer = log2((100*(pow(aperture!,2)))/(iSO!*shutterTime!))
        
        let calcString = "Footcandles:\(round(pow(2, answer)*2.5/10.76)), LV: \(round(answer)), Lux: \(round(((pow(2, answer))*2.5))) "
        return (calcString,answer)

    //aperture is missing
    }else if aperture == nil && iSO != nil && shutterTime != nil && LV != nil {
        
        //aperture calculation (sqrt(((exp2(LV!))*(iSO!*shutterTime!))/100)*100.0)/100.0
        let answer = (sqrt(((exp2(LV!))*(iSO!*shutterTime!))/100)*100.0)/100.0
        
        let calcString = "Calculated tStop: \(round(answer))"
        return (calcString,answer)
    
    //ISO is missing
    }else if iSO == nil && aperture != nil && shutterTime != nil && LV != nil {
        
        //ISO calculation (100*((pow(aperture!, 2))) / (exp2(LV!))/shutterTime!)
        let answer = (100*((pow(aperture!, 2))) / (exp2(LV!))/shutterTime!)    //ISO calculation
        
        let calcString = "ISO: \(round(answer))"
        return (calcString,answer)
    
    //shutterTime is missing
    }else if shutterTime == nil && aperture != nil && iSO != nil && LV != nil {
        
        //EV calculation (100*(pow(aperture!, 2)) / (exp2(LV!)))/iSO!
        let answer = (100*(pow(aperture!, 2)) / (exp2(LV!)))/iSO!
        
        let calcString = "shuttertime: \(rationalApproximationOf(x0:answer).0)/\(rationalApproximationOf(x0:answer).1) /sec."
        return (calcString,answer)
        
    }else if (shutterTime != nil) && (aperture != nil) && (iSO != nil) && (LV != nil) { //too many values are provided
        
        
        //recalculates LV because all values were provided

        let answer = log2((100*(pow(aperture!,2)))/(iSO!*shutterTime!))
        
        let calcString = "I am the one who tells it how it is.  There is \(round(pow(2, answer)*2.5/10.76)) footcandles:, \(round(answer)) LV, or \(round(((pow(2, answer))*2.5))) Lux in front of the lens."
        return (calcString,answer)
        
    }else{                                      //any other case which can lead to
        
        //not enough bloody values!!
        
        let answer = 0.0
        let calcString = "not enough values to calculate answer, lunkhead"
        return (calcString,answer)
    }
}


rationalApproximationOf(x0: 0.02083333333333333) // (3, 17)
exposureCalc(tStop: nil, ISO: 320, shutter: 1/48, LV: 6.8777442499490).0
exposureCalc(tStop: 2.8, ISO: nil, shutter: 1/48, LV: 6.8777442499490).0
exposureCalc(tStop: 2.8, ISO: 320, shutter: nil, LV: 6.8777442499490).0
exposureCalc(tStop: 2.8, ISO: 320, shutter: 1/48, LV: nil).0
exposureCalc(tStop: 2.8, ISO: 320, shutter: 1/48, LV: 7).0
exposureCalc(tStop: nil, ISO: nil, shutter: nil, LV: nil).0



