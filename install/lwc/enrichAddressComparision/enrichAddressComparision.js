import { api, LightningElement } from 'lwc';

export default class EnrichAddressComparision extends LightningElement {

    _geolocationStatus;
    _beforeBillingStreet;
    _beforeBillingCity;
    _beforeBillingPostalCode;
    _beforeBillingCountry;
    _beforeBillingLatitude;
    _beforeBillingLongitude;
    _afterBillingStreet;
    _afterBillingCity;
    _afterBillingPostalCode;
    _afterBillingCountry;
    _afterBillingLatitude;
    _afterBillingLongitude;
    _RAWResponse;

    @api 
    get geolocationStatus() { return this._geolocationStatus; }   
    set geolocationStatus(val) { this._geolocationStatus = val; }

    @api 
    get beforeBillingStreet() { return this._beforeBillingStreet; }   
    set beforeBillingStreet(val) { this._beforeBillingStreet = val; }

    @api 
    get beforeBillingCity() { return this._beforeBillingCity; }   
    set beforeBillingCity(val) { this._beforeBillingCity = val; }


    @api 
    get beforeBillingPostalCode() { return this._beforeBillingPostalCode; }   
    set beforeBillingPostalCode(val) { this._beforeBillingPostalCode = val; }

    @api 
    get beforeBillingCountry() { return this._beforeBillingCountry; }   
    set beforeBillingCountry(val) { this._beforeBillingCountry = val; }

    @api 
    get beforeBillingLatitude() { return this._beforeBillingLatitude; }   
    set beforeBillingLatitude(val) { this._beforeBillingLatitude = val; }

    @api 
    get beforeBillingLongitude() { return this._beforeBillingLongitude; }   
    set beforeBillingLongitude(val) { this._beforeBillingLongitude = val; }

    @api 
    get afterBillingStreet() { return this._afterBillingStreet; }   
    set afterBillingStreet(val) { this._afterBillingStreet = val; }

    @api 
    get afterBillingCity() { return this._afterBillingCity; }   
    set afterBillingCity(val) { this._afterBillingCity = val; }

    @api 
    get afterBillingPostalCode() { return this._afterBillingPostalCode; }   
    set afterBillingPostalCode(val) { this._afterBillingPostalCode = val; }

    @api 
    get afterBillingCountry() { return this._afterBillingCountry; }   
    set afterBillingCountry(val) { this._afterBillingCountry = val; }

    @api 
    get afterBillingLatitude() { return this._afterBillingLatitude; }   
    set afterBillingLatitude(val) { this._afterBillingLatitude = val; }

    @api 
    get afterBillingLongitude() { return this._afterBillingLongitude; }   
    set afterBillingLongitude(val) { this._afterBillingLongitude = val; }

    @api 
    get RAWResponse() { return this._RAWResponse; }   
    set RAWResponse(val) { this._RAWResponse = val; }

    divRAWResponseflag = false;

    //style = "display: none;"
    showRAWResponse(event) {
        this.divRAWResponseflag = !this.divRAWResponseflag;
        /* 
        var x = document.getElementById("divRAWResponse");

        let nodeList = this.template.querySelectorAll("div");
        for (let i = 0; i < nodeList.length; i++) {
            alert(i+">>>"+JSON.stringify(nodeList[i]));
        }

        alert("A KUKU 2");
        alert("A KUKU 2" + JSON.stringify(x));
        if (x.style.display === "none") {
            alert("A KUKU 3");
            x.style.display = "block";
        } else {
            alert("A KUKU 4");
            x.style.display = "none";
        }
        */
    }

}