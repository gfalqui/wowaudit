module Audit
  class BasicData < Data
    ESSENTIAL = true

    def add
      @character.data['name'] = @data['name']
      @character.data['class'] = CLASSES[@data.character_class.id]
      @character.data['realm'] = REALMS[@character.realm_id]&.name
      @character.data['faction'] = @data.faction.name
      @character.data['realm_slug'] = @character.realm_slug
      @character.data['character_id'] = @character.id
      @character.data['join_date'] = @character.created_at
      @character.data['note'] = @character.note || ""
      @character.data['rank'] = @character.rank.capitalize
      @character.data['blizzard_last_modified'] = @data.last_login_timestamp
      @character.data['gender'] = @data.gender.name
      @character.data['race'] = @data.race.name

      # Parse the role if it's valid, otherwise set the default role
      begin
        if ROLES[@character.role][CLASSES[@data.character_class.id]]
          @character.data['role'] = @character.role
        else
          raise RoleError
        end
      rescue
        @character.role = DEFAULT_ROLES[CLASSES[@data.character_class.id]]
        @character.data['role'] = @character.role
        @character.changed = true
      end
    end
  end
end
