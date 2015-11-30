$(document).ready(function() {
    var player1 ="John Doe";
    var player2 ="Jane Doe";
    var player1selection = "";
    var player2selection = "";
    var player1choices = [];
    var player2choices = [];
    var selcom = 0;
    var count = 0;
    var selection = [];
    var xoro = [];
    var cselection = 0;
    var turn = 0; //0=Player 1, 1=Player 2
    var play = "";
    var box = "";
    var cplayer = "";
    $("#board").hide();
     $("#replay").hide();
     
    $("#replay").click(function(){
        location.reload();
    }) ;
     
	$("#button").click(function(){
        player1 = $('input[name=player1]').val();
        player2 = $('input[name=player2]').val();

        $("#slide").slideToggle('slow');
        selcom++;
        checksel(selcom);
	});        
    
    function checksel(selcom){
        if(selcom === 2)
        {
            $("#pselect").hide();
            $("#button").hide();
            
            $("#turndisplay").html("<p>Player 1 Turn</p>");
            $("#board").show();
        }
    }
    $("#selection").click(function(e){
        
        if(e.target.id == "divx"){
            player1selection = "X";
            player2selection = "O";
        }else if(e.target.id == "divo"){
            player1selection = "O";
            player2selection = "X";
        }
        $("#selection").hide();
        $("#pselect").html("<p>Options Selected</p>");
        
        selcom++;
        checksel(selcom);
    });  
    
    $("#board").click(function(e){
    
    switch(e.target.id){
        case "aa":  cselection = 11;    break;
        case "ab":  cselection = 12;    break;
        case "ac":  cselection = 13;    break;
        case "ba":  cselection = 21;    break;
        case "bb":  cselection = 22;    break;
        case "bc":  cselection = 23;    break;
        case "ca":  cselection = 31;    break;
        case "cb":  cselection = 32;    break;
        case "cc":  cselection = 33;    break;
        default:
    }
    if(cselection > 0)
    {
        findbox(e.target.id,cselection);
    }
    
    function findbox(box,cselection)
    {
        if(!search(cselection))
        {
            switchturns();
            $("#"+box).html(play);
            xoro[count] = play;
            selection[selection.length] = cselection ;
            count++; 
            winner(count,play);
        }
    }
    
    function search(val){
        for (i=0;i<=count;i++){
            if(val === selection[i] ){ return 1;    }
        }return 0;
    }
    
    function switchturns(){
        if(turn===0){
            $("#turndisplay").html("<p>Player 2 Turn</p>");
            play=player1selection;
            turn=1;
        }
        else{
            $("#turndisplay").html("<p>Player 1 Turn</p>");
            play=player2selection;
            turn=0;
        } 
    }
    
    function winner(count,value){
        var j;
        var index;
        if(count%2){
            cplayer=player1;
            index=0;
        }
        else
        {
            cplayer=player2;
            index=1;
        }
        
        if(count>4)
        {
            j=check(11,12,13,index);
            j=check(21,22,23,index);
            j=check(31,32,33,index);
            j=check(11,21,31,index);
            j=check(12,22,32,index);
            j=check(13,23,33,index);
            j=check(11,22,33,index);
            j=check(13,22,31,index);
        }   
        if(count>8)
        {
            $("#debug").html("<p> It's a TIE</p>");
            $("#replay").show();
        }

    }
    function check(val1,val2,val3,index)
    {
        var j=0;
        for(var i=index;i<=8;i+=2){
            if(selection[i] == val1 || selection[i] == val2 || selection[i] == val3)
            {
                j++;
            }
        }
        if(j===3){ 
            $("#debug").html("<p>Winner!</p>");
            $("#replay").show();
            $("#turndisplay").hide();
            $("#board").effect("bounce",5000);
        }
        return j;
    }
    });
});