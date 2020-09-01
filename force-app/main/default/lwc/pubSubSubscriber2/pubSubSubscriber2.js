import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub' ; 
export default class PubsubSubscriber2 extends LightningElement {

    message;
    connectedCallback(){
        this.register();
    }
    register(){
        window.console.log('event registered ');
        pubsub.register('simplevt', this.handleEvent.bind(this));
        pubsub.register('simplevt1', this.handleEvent1.bind(this));
    }
    handleEvent(messageFromEvt){
        window.console.log('event handled ',messageFromEvt);
        this.message = messageFromEvt ? JSON.stringify(messageFromEvt) : 'no message payload';
    }
    handleEvent1(messageFromEvt){
        window.console.log('event handled ',messageFromEvt);
        this.message1 = messageFromEvt ? JSON.stringify(messageFromEvt) : 'no message payload';
    }
}