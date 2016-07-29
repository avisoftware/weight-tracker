.pragma library

var BMIClass = {
    VERY_SEVERELY_UNDERWEIGHT: 1,
    SEVERELY_UNDERWEIGHT: 2,
    UNDERWEIGHT: 3,
    NORMAL: 4,
    OVERWEIGHT: 5,
    OBESE: 6,
    OBESE_CLASS_I: 7,
    OBESE_CLASS_II:8,
    OBESE_CLASS_III:9
};
/*
arrBmi = [girl][age 2-20][underweight][normal][obese]
 [boys][age 2-20][underweight][normal][obese]
*/
var childBmi=[
            [[[14.2],[18.0],[19.1]],
             [[14.0],[17.2],[18.3]],
             [[13.7],[16.8],[18.0]],
             [[13.5],[16.8],[18.3]],
             [[13.4],[17.1],[18.8]],
             [[13.4],[17.6],[19.6]],
             [[13.5],[18.1],[20.6]],
             [[13.7],[19.1],[21.8]],
             [[14.0],[20.0],[23.0]],
             [[14.4],[20.8],[24.1]],
             [[14.8],[21.7],[25.2]],
             [[15.3],[22.5],[26.3]],
             [[15.8],[23.3],[27.2]],
             [[16.3],[24.0],[28.1]],
             [[16.8],[24.6],[28.9]],
             [[17.2],[25.2],[29.6]],
             [[17.5],[25.7],[30.3]],
             [[17.8],[26.1],[31.0]],
             [[17.9],[26.5],[31.8]]],
            [[[14.8],[18.2],[19.2]],
             [[14.4],[17.3],[18.3]],
             [[14.0],[16.9],[17.8]],
             [[13.8],[16.8],[17.9]],
             [[13.75],[17.0],[18.2]],
             [[13.7],[17.4],[19.1]],
             [[13.8],[17.9],[20.0]],
             [[14.0],[18.6],[21.0]],
             [[14.2],[19.4],[22.1]],
             [[14.6],[20.2],[23.2]],
             [[15.0],[21.0],[24.2]],
             [[15.4],[21.8],[25.2]],
             [[16.0],[22.6],[26.0]],
             [[12.6],[23.4],[26.8]],
             [[17.1],[24.1],[27.5]],
             [[17.7],[24.9],[28.2]],
             [[18.2],[25.6],[29.0]],
             [[18.7],[26.4],[29.7]],
             [[19.1],[27.0],[30.6]]]];
function getKidsClass(bmi,age,gender){
    if(bmi>0&&bmi<=childBmi[gender][age-2][0]){
        return BMIClass.UNDERWEIGHT;
    }else if(bmi>childBmi[gender][age-2][0]&&bmi<=childBmi[gender][age-2][1]){
        return BMIClass.NORMAL;
    }else if(bmi>childBmi[gender][age-2][1]&&bmi<=childBmi[gender][age-2][2]){
        return BMIClass.OVERWEIGHT;
    }else if(bmi>childBmi[gender][age-2][2]){
        return BMIClass.OBESE;
    }else{
        return 0;
    }
}

function getAdultClass(bmi){
    if(bmi>0&&bmi<=15){
        return BMIClass.VERY_SEVERELY_UNDERWEIGHT;
    }else if(bmi>15&&bmi<=16){
        return BMIClass.SEVERELY_UNDERWEIGHT;
    }else if(bmi>16&&bmi<=18.5){
        return BMIClass.UNDERWEIGHT;
    }else if(bmi>18.5&&bmi<=25){
        return BMIClass.NORMAL;
    }else if(bmi>25&&bmi<=30){
        return BMIClass.OVERWEIGHT;
    }else if(bmi>30&&bmi<=35){
        return BMIClass.OBESE_CLASS_I;
    }else if(bmi>35&&bmi<=40){
        return BMIClass.OBESE_CLASS_II;
    }else if(bmi>40){
        return BMIClass.OBESE_CLASS_III;
    }else{
        return 0
    }
}
function getfixedBmiForChild(bmi,gender,age){
    if(bmi<=childBmi[gender][age-2][0]){
        return (arrBmi[gender][age-2][0]);
    }else if(bmi>childBmi[gender][age-2][0]&&bmi<=childBmi[gender][age-2][1]){
        return 0;
    }else if(bmi>childBmi[gender][age-2][1]&&bmi<=childBmi[gender][age-2][2]){
        return (arrBmi[gender][age-2][1]);
    }else if(bmi>childBmi[gender][age-2][2]){
        return (arrBmi[gender][age-2][1]);
    }
}

function getfixedBmiForAdult(bmi){
    if(bmi<=15){
        return 18.5;
    }else if(bmi>15&&bmi<=16){
        return 18.5;
    }else if(bmi>16&&bmi<=18.5){
        return 18.5;
    }else if(bmi>18.5&&bmi<=25){
        return 0;
    }else if(bmi>25&&bmi<=30){
        return 25;
    }else if(bmi>30&&bmi<=35){
        return 25;
    }else if(bmi>35&&bmi<=40){
        return 25;
    }else if(bmi>40){
        return 25;
    }
}
function getBMIClass(bmi,age,gender){
    if(age<20){
        return getKidsClass(bmi,age,gender);
    }
    return getAdultClass(bmi);
}

function getTipToNormalBmi(bmi,lib,height,weight,age,gender){
    var fixedBmi =0;
    if (age<20){
        fixedBmi=getfixedBmiForAdult(bmi,gender,age);
    }else{
        fixedBmi= getfixedBmiForAdult(bmi);
    }
    var inc =1;
    if (lib){
        inc =703;
    }else{
        height = height /100;
    }
    var fixedWeight = (height*height)*(fixedBmi/inc)
    if(fixedWeight!==0){
        return  ( weight-(fixedWeight))
    }
    return 0;
}
// param lib is for if its libra
function getBmiNumber(lib,height,weight){
    if(weight>0 && height>0) {
        var inc =1;
        if(lib){
            inc =703;
        }else{
            height = height /100;
        }
        return ((weight / (height * height))*inc).toFixed(2);
    }
    return 0;
}
