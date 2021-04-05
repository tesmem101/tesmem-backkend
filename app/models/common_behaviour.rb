class CommonBehaviour < ActiveRecord::Base
    self.abstract_class = true
    class << self
        def only_deleted
            where(is_deleted: true)
        end
    
        def not_deleted
            where(is_deleted: false)
        end
    end

    def soft_delete
        self.update(is_deleted: true)
    end

    def soft_restore
        self.update(is_deleted: false)
    end

end