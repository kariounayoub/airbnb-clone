class BoatPolicy < ApplicationPolicy

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    record.owner == user
  end

  def edit?
    update?
  end

  def destroy?
    record.owner == user
  end



  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
