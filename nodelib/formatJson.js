s=process.openStdin();
d=[];
s.on('data',function(c) {
    d.push(c);
});
s.on('end',function() {
    var data;
    var dparsed;
    try {
        data = d.join('');
        dparsed = JSON.parse(data);
    } catch (err) {
        console.log(err.stack);
        console.log("input was: " + data);
    }
    if (dparsed) {
        console.log(JSON.stringify(dparsed,null,2));
    }
});
