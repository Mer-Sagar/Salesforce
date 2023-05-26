// <!-- =================: relatedObjectList :===================== -->
public with sharing class RelatedSObject {
    
    
    // static List<String> recList = new List<String>();

    public class Wrapper_RelatedSObject{
        @AuraEnabled
        public String childObjectName {get;set;}         
    }
    
    public class Wrapper_RelatedField{
        @AuraEnabled
        public String fieldName {get;set;} 
    }

    public class Wrapper_SelectedRecord{
        @AuraEnabled
        public String sel_rec {get;set;} 
    }

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


    // public class Wrapper_DisplayRecord{
    //     @AuraEnabled
    //     public List<String> display_sel_rec {get;set;} 
    // }
    
   
    @AuraEnabled(cacheable=true)
    public static List<Wrapper_RelatedSObject> getRelatedSobjects()
    {
        
        //SObjectType currentType = Schema.getGlobalDescribe().get('Account');
        integer count2=0;   
        List<Wrapper_RelatedSObject> relObj = new List<Wrapper_RelatedSObject>();
        
        Schema.DescribeSObjectResult res = Account.SObjectType.getDescribe();
        
        for (Schema.ChildRelationship cr: res.getChildRelationships())
        {           
                    

          
            if(cr.isRestrictedDelete() || String.valueOf(cr.getChildSObject()) == 'Contact' )
            {
                Wrapper_RelatedSObject wro = new Wrapper_RelatedSObject();
                wro.childObjectName = String.valueOf(cr.getChildSObject());

                system.debug('====Child Object==='+ String.valueOf(cr.getChildSObject()));

                relObj.add(wro);
        
                count2++;  
            }
                 
        	
        }
        
        system.debug(count2+'--->'+relObj);
        
         return relObj;
    }

    @AuraEnabled(cacheable=true)
    public static List<Wrapper_RelatedField> getRelatedFields(String sobj_name)
    {

        System.debug('Sobject name : --> '+sobj_name);
        
        List<Wrapper_RelatedField> relField = new List<Wrapper_RelatedField>();
        Map<String, Schema.SObjectType> res = Schema.getGlobalDescribe();
        
        for(Schema.SObjectField strFld : res.get(sobj_name).getDescribe().fields.getMap().Values())
        {
            System.debug('string filed : --> '+strFld);

            Wrapper_RelatedField wrfld = new Wrapper_RelatedField();
            wrfld.fieldName = String.valueOf(strFld);

            relField.add(wrfld);
        }
        system.debug('Fields ---> '+relField);
        
        return relField;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSelectedRecord(List<String> selected_rec)
    {
        List<String> recList = new List<String>();

        system.debug('--+-->'+selected_rec);
        recList.addAll(selected_rec);
        system.debug('====+=--+-->'+recList);
        
        getSelected(recList);

        return selected_rec;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSelected(List<String> recList)
    {
        
        System.debug('in 4th function'+recList);
        return recList;
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
        
         
        // Schema.DisplayType fieldtype = Schema.getGlobalDescribe();
        //for(Schema.SObjectField strFld : res.get('Contact').getDescribe().fields.getMap().Values())
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