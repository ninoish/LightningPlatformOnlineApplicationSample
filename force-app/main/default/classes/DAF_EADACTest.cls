@isTest
public with sharing class DAF_EADACTest {
  @TestSetup
  static void setup() {
    jpseps__objApplicationTemplate__c at = new jpseps__objApplicationTemplate__c(
      Name = 'テスト用申請手続き'
    );
    insert at;

    jpseps__objApplicationTemplatePage__c ap1 = new jpseps__objApplicationTemplatePage__c(
      Name = 'ページ1',
      Order__c = 1,
      jpseps__objApplicationTemplate__c = at.Id
    );
    insert ap1;

    List<jpseps__objApplicationTemplateRow__c> rows = new List<jpseps__objApplicationTemplateRow__c>();
    jpseps__objApplicationTemplateRow__c ar1_1 = new jpseps__objApplicationTemplateRow__c(
      Order__c = 1,
      AppTemplatePage__c = ap1.Id
    );
    rows.add(ar1_1);

    insert rows;

    List<jpseps__objApplicationTemplateDetail__c> atds = new List<jpseps__objApplicationTemplateDetail__c>();
    jpseps__objApplicationTemplateDetail__c atd1 = new jpseps__objApplicationTemplateDetail__c(
      objApplicationTemplate__c = at.Id,
      Name = '氏名',
      Category__c = '標準',
      StdColumnName__c = 'jpseps__FirstnameKanji__c',
      AppTemplateRow__c = ar1_1.Id,
      ColumnOrder__c = 1
    );

    atds.add(atd1);
    jpseps__objApplicationTemplateDetail__c atd2 = new jpseps__objApplicationTemplateDetail__c(
      objApplicationTemplate__c = at.Id,
      Name = '事業者名',
      Category__c = 'カスタム',
      AppTemplateRow__c = ar1_1.Id,
      ColumnOrder__c = 1
    );
    atds.add(atd2);
    insert atds;

    jpseps__objApplication__c a = new jpseps__objApplication__c(
      objApplicationTemplate__c = at.Id,
      FirstnameKanji__c = 'アストロ'
    );
    insert a;

    jpseps__objApplicationDetail__c ad = new jpseps__objApplicationDetail__c(
      objApplication__c = a.Id,
      objApplicationTemplateDetail__c = atds[1].Id,
      Text__c = 'アストロフォース'
    );
    insert ad;
  }

  @isTest
  static void testGetApplicationTemplates() {
    List<jpseps__objApplicationTemplate__c> records = DAF_ExportApplicationDataApexController.getApplicationTemplates();
    System.assertEquals(1, records.size());
  }

  @isTest
  static void testGetApplicationData() {
    jpseps__objApplication__c at = [
      SELECT Id, objApplicationTemplate__c
      FROM jpseps__objApplication__c
      WHERE FirstnameKanji__c = :'アストロ'
      LIMIT 1
    ];
    List<jpseps__objApplication__c> records = DAF_ExportApplicationDataApexController.getApplicationData(
      at.objApplicationTemplate__c
    );
    System.assertEquals(1, records.size());
  }

  @isTest
  static void testNoParameter() {
    List<jpseps__objApplication__c> records = DAF_ExportApplicationDataApexController.getApplicationData(
      ''
    );
    System.assertEquals(null, records);
  }

  @isTest
  static void testInvalidParameter() {
    List<jpseps__objApplication__c> records = DAF_ExportApplicationDataApexController.getApplicationData(
      'ABCDEDF'
    );
    System.assertEquals(0, records.size());
  }
}
