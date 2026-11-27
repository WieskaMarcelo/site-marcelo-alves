-- Sistema de leads do site. Rode no Supabase: SQL Editor > New query > cole tudo > Run.

create table if not exists public.leads (
  id            uuid primary key default gen_random_uuid(),
  criado_em     timestamptz not null default now(),
  nome          text not null check (char_length(nome) between 2 and 120),
  whatsapp      text not null check (char_length(whatsapp) between 10 and 25),
  email         text check (email is null or char_length(email) <= 160),
  negocio       text check (negocio is null or char_length(negocio) <= 160),
  tipo          text check (tipo is null or char_length(tipo) <= 60),
  investimento  text check (investimento is null or char_length(investimento) <= 60),
  prazo         text check (prazo is null or char_length(prazo) <= 60),
  mensagem      text check (mensagem is null or char_length(mensagem) <= 2000),
  origem        text not null default 'site' check (char_length(origem) <= 40),
  status        text not null default 'novo'
                check (status in ('novo','em_contato','proposta','fechado','perdido')),
  anotacoes     text check (anotacoes is null or char_length(anotacoes) <= 4000),
  atualizado_em timestamptz not null default now()
);

create index if not exists leads_criado_idx on public.leads (criado_em desc);
create index if not exists leads_status_idx on public.leads (status);

alter table public.leads enable row level security;

-- Expõe a tabela na API só com o mínimo necessário.
revoke all on public.leads from anon, authenticated;
grant insert on public.leads to anon;
grant select, update, delete on public.leads to authenticated;

-- Visitantes do site (chave anon) só podem CRIAR lead, sempre com status "novo".
drop policy if exists "site cria lead" on public.leads;
create policy "site cria lead" on public.leads
  for insert to anon
  with check (status = 'novo' and anotacoes is null);

-- Só o dono (login com este e-mail) lê e atualiza os leads.
drop policy if exists "dono le leads" on public.leads;
create policy "dono le leads" on public.leads
  for select to authenticated
  using ((auth.jwt() ->> 'email') = 'marceloalvesjf@gmail.com');

drop policy if exists "dono atualiza leads" on public.leads;
create policy "dono atualiza leads" on public.leads
  for update to authenticated
  using ((auth.jwt() ->> 'email') = 'marceloalvesjf@gmail.com')
  with check ((auth.jwt() ->> 'email') = 'marceloalvesjf@gmail.com');

drop policy if exists "dono apaga leads" on public.leads;
create policy "dono apaga leads" on public.leads
  for delete to authenticated
  using ((auth.jwt() ->> 'email') = 'marceloalvesjf@gmail.com');

-- Atualiza a data de modificação automaticamente.
create or replace function public.leads_touch() returns trigger
language plpgsql set search_path = '' as $$ begin new.atualizado_em = now(); return new; end $$;
drop trigger if exists leads_touch on public.leads;
create trigger leads_touch before update on public.leads
  for each row execute function public.leads_touch();
