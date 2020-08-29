<?php

use Craft;
use craft\base\Element;
use craft\elements\Entry;
use craft\helpers\ElementHelper;

/**
 * This test class is used as a workaround to setup the test
 * DB. See the `setup-tests` script in composer.json.
 */
class SmokeTest extends \Codeception\Test\Unit {

    public function testSmoke() {
        $site = Craft::$app->getSites()->getSiteByHandle('site1');
        $section = Craft::$app->getSections()->getSectionByHandle('section1');
        $entry = new Entry();
        $entry->title = '';
        $entry->siteId = $site->id;
        $entry->sectionId = $section->id;
        $entry->typeId = $section->getEntryTypes()[0]->id;
        $entry->slug = ElementHelper::tempSlug();
        $entry->setScenario(Element::SCENARIO_ESSENTIALS);
        self::assertTrue(Craft::$app->getElements()->saveElement($entry));
    }

}
