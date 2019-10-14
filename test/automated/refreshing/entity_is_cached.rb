require_relative '../automated_init'

context "Refreshing" do
  context "Entity is Cached" do
    stream_name = Controls::Write.batch(category: 'testRefreshingEntityCached')

    id = Messaging::StreamName.get_id stream_name
    category_name = Messaging::StreamName.get_category stream_name

    store = Controls::EntityStore.example(category: category_name)
    SubstAttr::Substitute.(:cache, store)

    cached_entity, cached_version = Controls::Entity::Cached.add(id, store)

## TODO How does this test and controls work?

    # assert(cached_entity.sum == 1)
    # assert(cached_version == 1)

    entity = store.get(id)

    test "Unprojected events are projected" do
      assert(entity.sum == Controls::Entity::Current.sum)
    end

    context "Cache update" do
      control_id = id

      test "Entity" do
        control_entity = Controls::Entity::Current.example

        put_record = store.cache.put? do |record|
          record.id == control_id && record.entity == control_entity
        end

        assert(put_record)
      end

      test "Version is refreshed" do
        control_version = Controls::Version::Current.example

        put_record = store.cache.put? do |record|
          record.id == control_id && record.version == control_version
        end

        assert(put_record)
      end

      test "Persisted version is set to previous persisted cache version" do
        control_persisted_version = Controls::Version::Cached.example

        put_record = store.cache.put? do |record|
          record.id == control_id && record.persisted_version == control_persisted_version
        end

        assert(put_record)
      end
    end
  end
end
