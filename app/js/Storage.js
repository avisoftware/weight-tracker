function getDatabase() {
    return LocalStorage.openDatabaseSync("weight-tracker", "1.0", "StorageDatabase", 1000000);
}
function initialize() {
    var db = getDatabase();
    console.log("initializing...")
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS weight(weight REAL, date DATE,userId INT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS users(id INT, name TEXT,age INT, height INT,gender INT)');
                    var a=  tx.executeSql('PRAGMA table_info(users)');
                    if(a.rows.length<5){
                        tx.executeSql(' ALTER TABLE users ADD COLUMN age INT;');
                        tx.executeSql(' ALTER TABLE users ADD COLUMN height INT;');
                        tx.executeSql(' ALTER TABLE users ADD COLUMN gender INT;');
                        console.log("updated user table")
                    }
                    if(usersCount()<=0&&!settings.isFirstUse){
                             insertUser("user1",settings.age,settings.height,settings.gender);
                        console.log("insert temp user")
                    }
                });
    console.log("initialized")

}
function deleteHistoryOnPeriod(period,userId){
    var db = getDatabase();
    var periodString="";
    var today = new Date();
    if (period === 0){
        var month = new Date(today.getFullYear(), today.getMonth()-1, today.getDate());
        periodString = ("( date < '"+Qt.formatDate(month,"yyyy-MM-dd")+"')")
    }else if(period === 1){
        var sixMonth = new Date(today.getFullYear(), today.getMonth()-6, today.getDate());
        periodString = ("( date < '"+Qt.formatDate(sixMonth,"yyyy-MM-dd")+"')")
    }else if(period === 2){
        var year = new Date(today.getFullYear()-1, today.getMonth()-1, today.getDate());
        periodString = ("( date < '"+Qt.formatDate(year,"yyyy-MM-dd")+"')")
    }
    else if(period === 3){
        var all = new Date(today.getFullYear(), today.getMonth(), today.getDate());
        periodString = ("1=1")
    }
    db.transaction(
                function(tx) {
                    tx.executeSql('DELETE FROM weight WHERE userId='+userId+' AND '+periodString);
                });
}
function deleteUser(userId){
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    if(usersCount()>1){
                        tx.executeSql('DELETE FROM weight WHERE userId='+userId);
                        tx.executeSql('DELETE FROM users WHERE id='+userId);
                    }
                });
}
function usersCount(){
    var userCount =0;
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM users');
                    userCount = rs.rows.length
                });
    return userCount;
}

function setWeight(weigth, date,userId) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT  INTO weight VALUES (?,?,?);', [weigth,date,userId]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    }
    );
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}
function findLastWeigth(userId) {
    var db = getDatabase();
    var lastWeight =0
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM weight WHERE userId=? ORDER BY date DESC;',[userId]);
        if(rs.rows.length>0){
            lastWeight=rs.rows.item(0).weight
        }
    }
    )
    return lastWeight;
}
function findLastDate(userId) {
    var db = getDatabase();
    var lastDate =0
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM weight WHERE userId=? ORDER BY date DESC;',[userId]);
        if(rs.rows.length>0){
            lastDate=Qt.formatDate(rs.rows.item(0).date,Qt.SystemLocaleShortDate)
        }
    }
    )
    return lastDate;
}
function getModelOfWeight(userId){
    var db = getDatabase();
    var arr=[];
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM weight WHERE userId=?  ORDER BY date',[userId]);
        for(var i =0;i < rs.rows.length;i++){
            arr.push(rs.rows.item(i));
        }
    }
    );
    return arr;
}

function getArrayWeightGenaral(userId) {
    var db = getDatabase();
    var res = "";
    var labels=[];
    var values=[];
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM weight WHERE userId=?  ORDER BY date',[userId]);
        for(var i =0;i < rs.rows.length;i++){
            labels.push(Qt.formatDate(rs.rows.item(i).date,"dd.MM.yy"));
            values.push(rs.rows.item(i).weight);
        }
    }
    );
    if (labels.length<2){
        return "";
    }
    res = {
        labels: labels,
        datasets: [{
                fillColor: "rgba(62, 179, 79, 0.4)" ,
                strokeColor: Qt.darker( UbuntuColors.green),
                pointColor: "rgba(62, 179, 79, 1)",
                pointStrokeColor: Qt.darker( UbuntuColors.green),
                data: values
            }]
    }

    return res;
}
function checkDateExist(date,userId){
    var db = getDatabase();
    var res = false;
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM weight WHERE date=? AND userId=?',[date,userId]);
        if(rs.rows.length){
            res=true;
        }
    }
    )
    return res;
}
function updateWeight(weigth, date,userId){
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('UPDATE weight SET weight=? WHERE date=? AND userId=?;', [weigth,date,userId]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    }
    );
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}
function deleteWeight( date,userId){
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM weight  WHERE date=? AND userId=?;', [date,userId]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    }
    );
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}
function getMaxUserId(){
    var maxId=0;
    var db = getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT MAX(id) AS id FROM users');
        if(rs.rows.item(0).id>0){
            maxId=rs.rows.item(0).id
        }
    }
    );
    return maxId;
}
function getMinUserId(){
    var minId=0;
    var db = getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT MIN(id) AS id FROM users');
        if(rs.rows.item(0).id>0){
            minId=rs.rows.item(0).id
        }
    }
    );
    return minId;
}
function getUserName(id){
    var name="";
    var db = getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT name FROM users WHERE id=?',[id]);
        if(rs.rows.item(0).id>0){
            name=rs.rows.item(0).name
        }
    }
    );
    return name;
}
function getUserDetails(id){
    var details={};
    var db = getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM users WHERE id=?',[id]);
        if(rs.rows.item(0)===undefined){
            initialize()
            rs = tx.executeSql('SELECT * FROM users WHERE id=?',[id]);
        }
        if(rs.rows.item(0).id>0){
            details=rs.rows.item(0)
        }


    }
    );
    return details;
}
function insertUser(userName,age,height,gender){
    var db = getDatabase();
    var id=0;
    db.transaction(function(tx) {
        id=getMaxUserId()+1
        tx.executeSql('INSERT  INTO users VALUES (?,?,?,?,?);', [id,userName,age,height,gender]);
    }
    );
    return id;
}
function updateUser(id,userName,age,height,gender){
    var db = getDatabase();
    db.transaction(function(tx) {
     var rs= tx.executeSql('UPDATE  users SET  name=?, age=?,height=?,gender=? WHERE id=?', [userName,age,height,gender,id]);
        console.log("user updated")
    }
    );
    return id;
}
function getArrayUsers(){
    var db = getDatabase();
    var users=[];
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM users');
        for(var i =0;i < rs.rows.length;i++){
            users.push([rs.rows.item(i).id,rs.rows.item(i).name]);
        }
    }
    );
    return users;
}
function getWeightDirectionFromLastTime (userId){
    var db = getDatabase();
    var wight=[];
    db.transaction(function(tx) {
        var qurey="SELECT weight FROM weight WHERE userId="+userId+"  ORDER BY date DESC LIMIT 2"
        var rs = tx.executeSql(qurey);
        for(var i =0;i < rs.rows.length;i++){
            wight.push((rs.rows.item(i).weight));

        }
    }
    );
    if(wight.length===0){
        return "-"
    }
    var sum = (wight[0]-wight[1]).toFixed(2);
    if(sum>0){
        return "u"
    }else if(sum<0){
        return "d"
    }else if(isNaN(sum)){
        return "-"
    }
    return "s"
}

function getWeightDirectionOnPeriod(period,userId){
    var db = getDatabase();
    var wight=[];
    var periodString ="";
    if (period === "lastWeek"){
        var today = new Date();
        var lastWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 7);
        periodString = ("( date <= '"+Qt.formatDate(today,"yyyy-MM-dd")+"' AND date >='"+Qt.formatDate(lastWeek,"yyyy-MM-dd")+"')")
    }else if(period === "lastMonth"){

    }

    db.transaction(function(tx) {
        var qurey="SELECT weight FROM weight WHERE userId="+userId+" AND "+periodString+" ORDER BY date"
        var rs = tx.executeSql(qurey);
        for(var i =0;i < rs.rows.length;i++){
            wight.push((rs.rows.item(i).weight));
        }
    }
    );
    var sum = (wight[wight.length-1]-wight[0]).toFixed(2);
    if(sum>0.1){
        return "up"
    }else if(sum<-0.1){
        return "down"
    }else{
        return "same"
    }

}
function getWeightAvgOnPeriod(period,userId){
    var db = getDatabase();
    var periodString ="";
    var avg =0;
    var today = new Date();
    if (period === "lastWeek"){
        var lastWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate()-7);
        periodString = ("( date <= '"+Qt.formatDate(today,"yyyy-MM-dd")+"' AND date >='"+Qt.formatDate(lastWeek,"yyyy-MM-dd")+"')")
    }else if(period === "lastMonth"){
        var lastMonth = new Date(today.getFullYear(), today.getMonth()-1, today.getDate());
        periodString = ("( date <= '"+Qt.formatDate(today,"yyyy-MM-dd")+"' AND date >='"+Qt.formatDate(lastMonth,"yyyy-MM-dd")+"')")
    }
    db.transaction(function(tx) {
        var qurey="SELECT avg(weight) as avgWeight FROM weight WHERE userId="+userId+" AND "+periodString+" ORDER BY date"
        var rs = tx.executeSql(qurey);
        if(rs.rows.length>0){
            if(rs.rows.item(0).avgWeight>0){
                avg=rs.rows.item(0).avgWeight;
            }
        }
    }
    );
    return avg

}
