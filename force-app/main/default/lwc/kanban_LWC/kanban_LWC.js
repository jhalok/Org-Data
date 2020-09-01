import { LightningElement, wire, track } from 'lwc';
import getKanbanWrap from '@salesforce/apex/kanbanController.getKanbanWrap';
import getUpdatePickList from '@salesforce/apex/kanbanController.getUpdatePickList';
import { NavigationMixin } from 'lightning/navigation';
export default class KanbanView extends LightningElement {

    @track kanbanData;
    @track mapOfListValues = [];
    @track kanbanUpdateData;
    @track errors;
    @track kanbanActualTable;
    /* @track kanbanActualTable = {
        columnName
    } */
    //Apex wire Method to a Property
    @wire(getKanbanWrap, { objName: 'Case', objFields: ['Reason', 'Status'], kanbanField: 'Status' })
    wiredKanban({ error, data }) {
        if (data) {
            console.log(JSON.stringify(data.recordsCount));
            this.kanbanData = data;
            console.log(JSON.stringify(this.kanbanData.recordsCount));
            console.log(JSON.stringify(this.kanbanData.pickVals));
            for (let key in data.mapStage) {
                // Preventing unexcepted data
                if (data.mapStage.hasOwnProperty(key)) { // Filtering the data in the loop
                    this.mapOfListValues.push({ key: key, value: data.mapStage[key] });
                }
            }
            console.log(JSON.stringify(this.mapOfListValues));
            //console.log(JSON.stringify(this.kanbanData.records[0].Name));




        } else if (error) {
            this.errors = error;
        }
    }




    handleDrag(event) {
        console.log('drag' + event.dataTransfer.setData("liId", event.target.id));
        event.dataTransfer.setData("divKey", event.target.id);
    }

    handleAllowDrop(event) {
        console.log('drop allow');
        event.preventDefault();
    }

    handleDrop(event) {
        console.log('inside drop');
        console.log('drop' + event.dataTransfer.getData("divKey"));
        event.preventDefault();
        //var divId = event.dataTransfer.getData("divId");
        //console.log('divId' + divId);
        //console.log('event.target' + event.target);

        //var draggedElement = this.template.querySelectorAll("divId");
        //console.log('draggedElement');
        //draggedElement.classList.add('completed');
        //console.log('draggedElement1111111');
        //event.target.appendChild(draggedElement);
        //console.log('drDrop');

        event.preventDefault();
        var divId = event.dataTransfer.getData("divKey");
        var draggedElement = this.template.querySelector("divKey");
        draggedElement.classList.add('completed'); 
        event.target.appendChild(draggedElement);


        /*    event.preventDefault();
  
  
          var data = event.dataTransfer.getData("liId");
          console.log('data' + data);
          var tar = event.target;
          /* console.log('tar' + tar);
          while (tar.tagName != 'ul' && tar.tagName != 'UL')
              console.log('targetName' + tar.tagName);
          tar = tar.parentElement;
          console.log('targetParnetName' + tar); */
        // event.target.appendChild(this.template.querySelector('#' + liId));
        /*   document.getElementById(data).style.backgroundColor = "#ffb75d"; 
        console.log('target' + event.tar);*/

        /* 
                getUpdatePickList({ recId: data, kanbanField: 'StageName', kanbanNewValue: tar.getAttribute('data-pick-val') })
                    .then(result => {
        
                        this.kanbanUpdateData = result;
                    })
                    .catch(error => {
        
                        console.log('==========' + error);
                    }) */

    }


    doView(event) {

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.id,
                objectApiName: 'Case',
                actionName: 'view'
            },
        });

    }
    get styleAttr() {
        return 'width:calc(100vw/' + (this.kanbanData.pickVals.length + 0.5) + ')';
    }

    /* get hasRendered() {
       console.log('val');
        // console.log(JSON.stringify(this.kanbanData.pickVal) + JSON.stringify(this.kanbanData.StageName));
        for (var i = 0; i < this.kanbanData.recordsCount.length; i++) {
            /// console.log('recordsCount  length' + JSON.stringify(this.kanbanData.recordsCount.length));
            // console.log('recordsCount' + JSON.stringify(this.kanbanData.recordsCount));
            // console.log('i' + i);
            for (var j = 0; j < this.kanbanData.records.length; j++) {
              console.log('j' + j);
                console.log('records length' + JSON.stringify(this.kanbanData.records.length));
                console.log('records' + JSON.stringify(this.kanbanData.records));
                console.log('val1' + JSON.stringify(this.kanbanData.recordsCount[i].value));
                console.log('val2' + JSON.stringify(this.kanbanData.records[j].StageName));
                if (this.kanbanData.recordsCount[i].value == this.kanbanData.records[j].StageName) {
                    console.log('t') 
                    return 'true';

                }


            }
        }


    } */
}