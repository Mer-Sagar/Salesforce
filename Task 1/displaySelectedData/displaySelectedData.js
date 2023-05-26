import { LightningElement, api,track,wire } from 'lwc';
import SELECTED_FIELD_Channel from '@salesforce/messageChannel/selecteddata__c';
import { subscribe, MessageContext } from 'lightning/messageService';

// import getSelectedRecord from '@salesforce/apex/RelatedSObject.getSelectedRecord';

export default class DisplaySelectedData extends LightningElement {

    data=[];
    @track recordData;
    @api childvalue=[];
    subscription = null;
    
    @wire(MessageContext)
    context;

    connectedCallback()
    {
        this.selectedField();
    }

    selectedField() 
    {
        if(this.subscription)
        {
            return;
        }

        this.subscription = subscribe(this.context, SELECTED_FIELD_Channel, (dataValue)=>{

            this.recordData = dataValue.fieldName;
            
            console.log('======---======> '+ this.recordData);
            // console.log('1---> '+ this.stringFromSearchBox);
            // this.searchAccount();
        });            

        
    }


    lst=['abc','aaa','bbbb'];

    // @api childvalue;
    
    // @track recordData;
    @api addSelectedValues()
    {
        this.recordData = this.childvalue;
        console.log('Child List ---> '+ this.recordData);
    }
   

    // getSelectedRecord({
    //     recList : lst
    // }).then(result => {
    //     console.log('Data List ---> '+ this.result);
    //     //this.data = result;
    // }).catch(error=>{
    //     //this.data = error;
    // });  
    
    
        
     

   

}