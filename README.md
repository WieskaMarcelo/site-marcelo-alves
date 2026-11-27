# Site + sistema de leads

Arquivos:
- `index.html`: o site. O formulário abre o WhatsApp e, com o Supabase configurado, salva o lead.
- `admin.html`: seu painel privado de leads (login, filtro por status, anotações, exportar CSV).
- `config.js`: onde vão a URL e a chave anon do Supabase.
- `supabase/schema.sql`: cria a tabela `leads` com as regras de segurança.

## Status da configuração (27/11/2026)

Feito:
- Projeto Supabase `site-leads` criado (região São Paulo).
- Tabela `leads` e regras de segurança aplicadas (`supabase/schema.sql`).
- Usuário marceloalvesjf@gmail.com convidado; novos cadastros desligados.
- `config.js` preenchido com a URL e a chave pública (publishable).
- Teste: o site consegue gravar lead (1 lead "Teste de configuração" foi criado, pode apagar) e ninguém sem login consegue ler.

Falta:
1. Hospedar a pasta (index.html, admin.html, config.js) na Vercel, Netlify ou GitHub Pages.
2. No Supabase, em Authentication > URL Configuration, trocar o Site URL para o endereço do `admin.html` hospedado.
3. Abrir o `admin.html`, digitar seu e-mail e clicar em "Receber link por e-mail".

## Passo a passo original (referência)

1. Crie uma conta grátis em https://supabase.com e um projeto novo (região: South America, São Paulo).
2. No projeto, abra **SQL Editor > New query**, cole todo o `supabase/schema.sql` e clique em **Run**.
3. Em **Authentication > Users > Add user > Create new user**, crie o usuário `marceloalvesjf@gmail.com` com uma senha forte (marque "Auto confirm").
4. Em **Authentication > Sign In / Providers**, desligue **Allow new users to sign up**. Assim ninguém mais cria conta.
5. Em **Project Settings > API**, copie a **Project URL** e a chave **anon public** e cole no `config.js`.
   Nunca use a chave `service_role` no site.
6. Hospede a pasta (index.html, admin.html, config.js) na Vercel, Netlify ou GitHub Pages.
7. Teste: envie um orçamento pelo site e veja o lead aparecer em `seudominio/admin.html`.

## Segurança
- O site só consegue **criar** leads. Ler, editar e apagar exige login com o seu e-mail.
- Campo escondido anti-robô no formulário e limites de tamanho em todos os campos.
