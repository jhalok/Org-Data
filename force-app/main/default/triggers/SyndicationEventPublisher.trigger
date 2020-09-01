trigger SyndicationEventPublisher on Syndication_Event__e (after insert) {
	SyndicationEventHandler s = new SyndicationEventHandler();
    s.handleSyndicationChanges(trigger.new);
}