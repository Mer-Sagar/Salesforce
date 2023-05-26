import { LightningElement,wire,track,api} from 'lwc';
import getRelatedSobjects from '@salesforce/apex/RelatedSObject.getRelatedSobjects';
import getRelatedField from '@salesforce/apex/RelatedSObject.getRelatedFields';
import getSelectedRecord from '@salesforce/apex/RelatedSObject.getSelectedRecord';

import SELECTED_FIELD_Channel from '@salesforce/messageChannel/selecteddata__c';
import { publish, MessageContext } from 'lightning/messageService';


const columns = [
    { label: 'Related sObjects' ,fieldName : 'childObjectName'},
    {label : 'Action', type: "button", typeAttributes: {  
        label: 'View Fields',  
        name: 'View',  
        title: 'View Fields',  
        disabled: false,  
        value: 'view',  
        iconPosition: 'center'  
    } }
];

const columnsField = [
    { label: 'Field Name' ,fieldName : 'fieldName'}
    
];

export default class ReletedObjectList extends LightningElement {

    @track columns = columns;
    @track data=[]; 
    
    @track selectedRec=[]; 

    @track columnsField = columnsField;
    @track fieldData=[]; 

    @track modelFlag = false;

    // selectedRecords;

    @wire(MessageContext)
    context;

   
   
    @wire(getRelatedSobjects)
    getRelatedSobj({data,error})
    {
        
        if(data)
        {
            this.data = data;

            console.log('Data : ==>'+this.data);
        }
        else if(error)
        {
            console.log('Eroor : ==>'+JSON.stringify(error));
        }

    }
    handleRowAction(event)
    {
       
        const actionName = event.detail.action.name;
        const field_name = event.detail.row.childObjectName;
               

        if(actionName=='View')
        {
            this.modelFlag = true;
            //this.submitRecord();

            console.log('Data table ---> '+ field_name);

            getRelatedField({

                sobj_name : field_name

            }).then(result => {
                console.log('Data table ---> '+ JSON.stringify(result));
                this.fieldData = result;
            }).catch(error=>{
                this.fieldData = error;
            });          
            
            

        }
        
    }

    submitRecord()
    {
        var selectedRecords = this.template.querySelector("lightning-datatable[data-field='field_table']").getSelectedRows(); 
        
        for(var i=0; i<selectedRecords.length; i++)
        {
            console.log(':---->'+JSON.stringify(selectedRecords[i].fieldName));
            this.selectedRec.push(selectedRecords[i].fieldName);
        }

        console.log('Hello '+this.selectedRec);    
        
        const payload = {
            fieldName : this.selectedRec,      
          
        };
         
        this.searchString = this.stringFromUser;
        console.log('Payload JSON-->' + JSON.stringify(payload.fieldName));

        publish(this.context, SELECTED_FIELD_Channel, payload );
        

        
        

        // getSelectedRecord({

        //     selected_rec : this.selectedRec

        // });    

        
        // Access child method
        this.template.querySelector('c-display-Selected-Data').addSelectedValues();

        this.selectedRec=[];
        this.closeModalAction();

        

    }

    

    closeModalAction()
    {
        this.modelFlag = false;
    }

    

    

   

    
}