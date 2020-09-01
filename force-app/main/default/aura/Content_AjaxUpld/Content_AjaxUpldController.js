({
    afterScriptsLoaded : function(component, event, helper) {
        console.log('script loaded');
      	this.jqueryMthd();  
    },
    jqueryMthd :function(component, event, helper){
    console.log('inside jquery mthd');
    var PARENT_ID = '0036F00003MnmyE'; //change Id to your record Id
        jQuery(document).ready(function($) {
            console.log('inside jquery');
            $('input').on('change', function(e){
                console.log('inside input chnage');
                for (var i = 0; i < this.files.length; i++) {
                    uploading += 1;
                    upload_file(this.files[i], PARENT_ID, function(err, res){ 
                        console.log('calling uploadFile mthd');
                        if (uploading === uploaded){
                            console.log('uploaded'); //your operation once finish
                            alert('upload completed');
                        }
                    })
                }
            });          
        })
	}
})