// <!-- =================: relatedObjectList :===================== -->
public with sharing class RelatedSObject {
    
    
   

    public class Wrapper_ContactField{

        @AuraEnabled
        public String cont_id {get;set;} 

        @AuraEnabled
        public String cont_field {get;set;} 
        
        @AuraEnabled
        public String field_type {get;set;} 

        @AuraEnabled
        public String s_object {get;set;}
    }

    public class Wrapper_Releated_Field
    {

        @AuraEnabled
        public String cont_id {get;set;} 

        @AuraEnabled
        public String cont_field {get;set;} 
        
        @AuraEnabled
        public String field_type {get;set;} 

        @AuraEnabled
        public String s_object {get;set;}
    }



    // -------============== getContactField() for contactFieldParent ==============------------------
    
    @AuraEnabled(cacheable=true)
    public static List<Wrapper_ContactField> getContactField()
    {

        //System.debug('Sobject name : --> '+sobj_name);
        
        List<Wrapper_ContactField> relField = new List<Wrapper_ContactField>();
        
        Map<String, Schema.SObjectType> res = Schema.getGlobalDescribe();        
        Schema.SObjectType leadSchema = res.get('Contact');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
         
        
        Integer counter = 1;
		
        for(String fieldName: fieldMap.keySet())
        {
            
            String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();            
            // System.debug('string filed : --> '+fieldLabel);

            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();   
           // System.debug(fieldName+' --> '+fielddataType);

            String fild = fieldName;
          //System.debug(fild+' --> '+fielddataType);
                      
            
            String objectName = 'Contact';
            //String fieldName =  'accountid';

            Schema.DescribeFieldResult f =  Schema.getGlobalDescribe()
                                            .get(objectName)
                                            .getDescribe()
                                            .fields
                                            .getMap()
                                            .get(fild)
                                            .getDescribe();
            
          //  System.debug('Lookup reference object name: ' + f);
         
            for(Schema.SObjectType reference : f.getReferenceTo()) {
                	System.debug(reference.getDescribe().getName()+' =:=> '+fild+' --> '+fielddataType);
               // System.debug('Lookup reference object name: ' + reference.getDescribe().getName());
               // System.debug('Lookup reference object label: ' + reference.getDescribe().getLabel());
            
			
                Wrapper_ContactField wrfld = new Wrapper_ContactField();
                wrfld.cont_id = String.valueOf(counter);
                wrfld.cont_field = String.valueOf(fieldLabel);
                wrfld.field_type = String.valueOf(fielddataType);
                wrfld.s_object = String.valueOf(reference.getDescribe().getName());
                counter++;

                relField.add(wrfld);
            }
        }
        system.debug('Fields ---> '+relField);
        
        return relField;
    }

     // -------============== getSobjectFields() for contactFieldParent ==============------------------

    @AuraEnabled
    public static List<Wrapper_Releated_Field> getSobjectFields(String sobj_name)
    {
        

        //System.debug('Sobject name : --> '+sobj_name);
        
        List<Wrapper_Releated_Field> relField = new List<Wrapper_Releated_Field>();
        
        Map<String, Schema.SObjectType> res = Schema.getGlobalDescribe();        
        Schema.SObjectType leadSchema = res.get(sobj_name);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
         
        // Schema.DisplayType fieldtype = Schema.getGlobalDescribe();
        //for(Schema.SObjectField strFld : res.get('Contact').getDescribe().fields.getMap().Values())
        Integer counter = 1;
        for(String fieldName: fieldMap.keySet())
        {
            
            String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();            
            // System.debug('string filed : --> '+fieldLabel);

            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();   
           // System.debug(fieldName+' --> '+fielddataType);

            //String fild = fieldName;
          //System.debug(fild+' --> '+fielddataType);
                      
            
          // String objectName = 'Contact';
            //String fieldName =  'accountid';

            Schema.DescribeFieldResult f =  Schema.getGlobalDescribe()
                                            .get(sobj_name)
                                            .getDescribe()
                                            .fields
                                            .getMap()
                                            .get(fieldName)
                                            .getDescribe();
            
          //  System.debug('Lookup reference object name: ' + f);
          Wrapper_Releated_Field wrfld = new Wrapper_Releated_Field();
                wrfld.cont_id = String.valueOf(counter);
                wrfld.cont_field = String.valueOf(fieldLabel);
                wrfld.field_type = String.valueOf(fielddataType);
         
            for(Schema.SObjectType reference : f.getReferenceTo()) {
                	System.debug(reference.getDescribe().getName()+' =:=> '+fieldName+' --> '+fielddataType);
               // System.debug('Lookup reference object name: ' + reference.getDescribe().getName());
               // System.debug('Lookup reference object label: ' + reference.getDescribe().getLabel());
            
			
               
                wrfld.s_object = String.valueOf(reference.getDescribe().getName());
               
            }
            counter++;

            relField.add(wrfld);
        }
        system.debug('Fields ---> '+relField);
        
        return relField;
        
    }


}