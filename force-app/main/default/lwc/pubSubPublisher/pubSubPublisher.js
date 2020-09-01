import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub' ; 
export default class PubsubPublisher extends LightningElement {

    handleClick(){
        window.console.log('Event Firing..... ');
        let message = 'Alok jha'; /*{
            "message" : 'Hello PubSub'
        }*/
        pubsub.fire('simplevt', message );
        window.console.log('Event Fired ');
        let message1 = 'Second sub';
        pubsub.fire('simplevt1', message1);
    }
}