import { LightningElement, api, track } from 'lwc';

export default class ContactFieldChild extends LightningElement {

      @api childvalue = [];    
      @track recordData =[];
      // @track showComponent = true;

//       connectedCallback(){
//         addSelectedValues();
//    } 
      @api addSelectedValues()
      {
        // if(this.childvalue.length != 0){
          this.recordData = this.childvalue;
          console.log('Child List ---> '+ JSON.stringify(this.recordData));
        // }
      }
}