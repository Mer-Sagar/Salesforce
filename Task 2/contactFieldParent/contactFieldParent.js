import { LightningElement,track,wire } from 'lwc';
import getContactField from '@salesforce/apex/RelatedSObject.getContactField';
import getSobjectFields from '@salesforce/apex/RelatedSObject.getSobjectFields';

export default class ContactFieldParent extends LightningElement {

    @track data=[];     
    @track selectedRec=[]; 
     showComponent = false;
     loaded = false;

     @track isLoading = false;

     @track error;
  
  

    @wire(getContactField)
    getContField({data,error})
    {
        
        if(data)
        {
            this.data = data;

            console.log('Data : ==>'+JSON.stringify(this.data));
        }
        else if(error)
        {
            console.log('Eroor : ==>'+JSON.stringify(error));
        }
        if(data || error){
            this.loaded = true;
        }

    }

    async clickToShow(event)
    {        
       
       const record_onClick_id = event.target.value;
       console.log('ID : ==>'+record_onClick_id);

       this.showComponent=true;

        if(event.target.checked == false)
        {
            this.template.querySelector('c-contact-field-child[data-id="'+record_onClick_id+'"]').setAttribute('hidden',true);
        }
        else
        {   this.isLoading = true;
            this.template.querySelector('c-contact-field-child[data-id="'+record_onClick_id+'"]').removeAttribute('hidden');
        }
       
        const record_onClick_sobject = event.target.dataset.sobject;
        console.log('Sobject : ==>'+record_onClick_sobject);

        await getSobjectFields(
            {
                sobj_name : record_onClick_sobject
            })
        .then(result => 
            {
                
		        this.selectedRec =result;
                this.isLoading = false;

        }).catch(error => 
            {
             console.log('error-->'+JSON.stringify(error));
             this.error = error;	
             this.isLoading = false; 
        })

     
        this.template.querySelector('c-contact-field-child[data-id="'+record_onClick_id+'"]').addSelectedValues();
    
            


       
        
        
    }

    
}