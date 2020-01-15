module Audit
  class CollectionData < Data
    def add
      @character.data['achievement_points'] =
        @data.legacy['achievementPoints']

      @character.data['mounts'] =
        @data.legacy['statistics']['subCategories'][0]['subCategories'][2]['statistics'][7]['quantity']

      # not working at the moment
      @character.data['titles'] = 0

      pets_owned = []
      level_25_pets = 0

      @data.legacy['pets']['collected'].each do |pet|
        unless pets_owned.include?(pet['creatureId'])
          pets_owned << pet['creatureId']
          level_25_pets += pet['stats']['level'] == 25 ? 1 : 0
        end
      end

      @character.data['unique_pets'] =
        @data.legacy['achievements']['criteriaQuantity'][@data.legacy['achievements']['criteria'].index(19598)] rescue pets_owned.size
      @character.data['lvl_25_pets'] = level_25_pets
    end
  end
end
