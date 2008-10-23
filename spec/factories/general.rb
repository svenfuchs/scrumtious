Factory.define :scrumtious, :class => Project do |p|
  p.remote_id 1
  p.name 'Scrumtious'
  p.lighthouse_account 'artweb'
  p.lighthouse_token 'lighthouse_token'
end

Factory.define :release_001, :class => Release do |r|
  r.project {|a| a.association(:scrumtious) }
  r.remote_id 1
  r.name '0.0.1'
  r.start_at '2008-10-01'
  r.end_at '2008-12-01'
end

Factory.define :sprint_1, :class => Sprint do |r|
  r.remote_id 2
  r.name '#1'
  r.start_at '2008-10-01'
  r.end_at '2008-10-07'
end

Factory.define :sprint_2, :class => Sprint do |r|
  r.remote_id 3
  r.name '#2'
  r.start_at '2008-10-08'
  r.end_at '2008-10-14'
end

Factory.define :component_1, :class => Component do |c|
  c.project {|a| a.association(:scrumtious) }
  c.name 'component 1'
end

Factory.define :category_1, :class => Category do |c|
  c.project {|a| a.association(:scrumtious) }
  c.name 'category 1'
end

Factory.define :user do |f|
  f.remote_id 1
  f.name 'John Doe'
end